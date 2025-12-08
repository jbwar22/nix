lib: with lib; rec {
  # enum helpers

  # definition list of enums
  _enums = {
    os = [ "nixos" "debian" ];
    cpu-vendors = [ "intel" "amd" ];
    gpu-vendors = [ "nvidia" "amd" "intel" ];
    namespace = [ "namespace-marker" ];
  };

  # create unique enum strings
  _genEnums = base: proto: if typeOf proto == "set" then (
    mapAttrs (name: value: _genEnums (base + "." + name) value) proto
  ) else (
    listToAttrs (map (name: {
      name = name;
      value = base + "." + name;
    }) proto)
  );

  # final enum obj for use
  enums = _genEnums "" _enums;


  # flake helpers

  flake-helpers = {
    forAllHostnames = hosts: genAttrs (attrNames hosts);

    forAllHostUserPairs = pairs: f: listToAttrs (map ({hostname, username}:
      nameValuePair "${username}@${hostname}" (f hostname username)
    ) pairs);

    getNixosHosts = filterAttrs (_name: value: value.os == enums.os.nixos);

    getNonNixosHosts = filterAttrs (_name: value: value.os != enums.os.nixos);

    isNixosHost = host: host.os == enums.os.nixos;

    genHostUserPairs = hosts: concatMap (hostname:
      map (username: { inherit hostname username; }) (attrNames hosts.${hostname}.users)
    ) (attrNames hosts);

    getConfigurationRevisionOverlay = (channel: final: prev: {
      lib = prev.lib.extend (import "${channel}/lib/flake-version-info.nix" channel);
    });
  };


  # namespace helper

  # generate namespace helpers given config and a path, from which the namespace will be determined
  # example: (in which ./. refers to flakeRoot/modules/home/programs/example)
  # x = ns config ./.;
  # x = {
  #   cfg = config.custom.home.programs.example;
  #   opt = (val: { custom.home.programs.example = val; });
  # }
  # (code annotated with example)
  ns = config: modulePath: let
    modulesRoot = ../modules;
    customNamespaceList = pipe modulePath [   # flakeRoot/modules/home/programs/example
      (path.removePrefix modulesRoot)         # "./home/programs/example"
      (splitString "/")                       # [ "." "home" "programs" "example" ]
      tail                                    # [ "home" "programs" "example" ]
      (concat [ "custom" ])                   # [ "custom" "home" "programs" "example" ]
    ];
  in {
    cfg = getAttrFromPath customNamespaceList config;   # config.custom.home.programs.example
    opt = setAttrByPath customNamespaceList;            # (val: { custom.home.programs.example = val; })
  };


  # non-path based namespace helpers

  # for use in attrset that determines namespace
  nsref = enums.namespace.namespace-marker;

  # get a list of attrset names leading to nsref in a simple attrset
  # example:
  # [ "a" ] { b.c.d = nsref; } -> [ "a", "b", "c", "d" ]
  getPathFromAttr = currpath: attr: if attr == ns then currpath else let
    next = findFirst (_: true) null (attrNames attr);
  in getPathFromAttr (currpath ++ [ next ]) attr.${next};

  # generate namespace helpers given simple attrset defining namespace 
  # example: use `with` to bring helpers into module context
  # with lib; with manualns config { home.programs.test = nsref }; { ... }
  manualns = config: namespace: let
    customNamespaceList = getPathFromAttr [ "custom" ] namespace;
  in {
    cfg = getAttrFromPath customNamespaceList config;
    opt = setAttrByPath customNamespaceList;
  };



  # file helpers

  # get all files and directories in a directory matching predicates on type and name
  # example: import all directories (all must contain default.nix) except "asdf"
  # imports = filterFromDir ./. (type: type == "directory") (name: name != "asdf");
  filterFromDir = dir: typepredicate: filepredicate: pipe dir [
    builtins.readDir
    (filterAttrs (file: type:
      typepredicate type && filepredicate file
    ))
    (mapAttrsToList (file: _: path.append dir file))
  ];
  getDirsFilter = dir: filepredicate: filterFromDir dir (type: type == "directory") filepredicate;
  getDirs = dir: getDirsFilter dir (_: true);
  getFilesFilter = dir: filepredicate: filterFromDir dir (type: type != "directory") filepredicate;
  getFiles = dir: getFilesFilter dir (_: true);

  getDir = dir: mapAttrs (file: type:
    if type == "directory" then getDir (path.append dir file) else type
  ) readDir dir;

  getConfigPath = config: configPath: pipe configPath [
    (path.removePrefix ../.)
    (substring 1 (-1))
    (x: config.custom.common.opts.hardware.configLocation + x)
  ];

  # user helpers

  getAdmins = filterAttrs (_username: user: user.admin);
  getTSOp = users: pipe users [
    getAdmins
    attrNames
    (ns:
      if length ns == 1
      then head ns
      else pipe users [
        getAdmins
        (filterAttrs (_username: user: user.tsop))
        attrNames
        (ns:
          if length ns == 1
          then head ns
          else throw "must have only one admin or only one admin+tsop configured"
        )
      ]
    )
  ];

  # check if a user's home-manager config matches a predicate
  # example: check if javkson has bash enabled
  # isUserPredicate config "jackson" (cfg: cfg.programs.bash.enable)
  isUserPredicate = config: username: predicate: predicate config.home-manager.users.${username};

  # check if (all/any) users in a given list's home-manager config matches a predicate
  # example: check if ANY admin has bash enabled
  # checkHMOptForUsers config (getAdmins config.custom.common.opts.host.users) any (cfg: cfg.programs.bash.enable)
  checkHMOptForUsers = config: users: boolListCheck: predicate: boolListCheck (username:
    isUserPredicate config username predicate
  ) (attrNames users);

  # check if (all/any) users on the host's home-manager config matches a predicate
  # example: check if ALL users have bash enabled
  # checkHMOpt config all (cfg: cfg.programs.bash.enable)
  checkHMOpt = config: boolListCheck: predicate: checkHMOptForUsers config (config.custom.common.opts.host.users) boolListCheck predicate;

  # mkIf any home-manager user passes predicate, then true
  # example: mk true if any home-manager user has bash enabled
  # mkIfAnyHMOpt config (cfg: cfg.programs.bash.enable)
  mkIfAnyHMOpt = config: predicate: mkIf (checkHMOpt config any predicate);

  getHMOptWithUsername = config: getter: users: map (username: getter config.home-manager.users.${username} username) (attrNames users);

  getHMOpt = config: getter: users: getHMOptWithUsername config (c: _: getter c) users;


  # users = setUserGroups config.custom.common.opts.host.users [ "group" ];
  setUserGroups = users: groups: {
    users = mapAttrs (username: user: {
      extraGroups = groups;
    }) users;
  };

  # elem "wheel" (getUserGroups config "jackson")
  getUserGroups = config: user: config.users.users.${user}.extraGroups;

  hasGroup = config: osConfig: group: elem group (getUserGroups osConfig config.home.username);


  # module helpers

  mkNsEnableModule = config: modulePath: body: with ns config modulePath; let
    flakeRoot = ./..;
    relativeModulePath = path.removePrefix flakeRoot modulePath;
  in {
    options = opt {
      enable = mkEnableOption "the module located at ${relativeModulePath}";
    };
    config = mkIf cfg.enable body;
  };


  # option helpers

  mkStrOption = description: mkOption {
    inherit description;
    type = types.str;
  };

  mkEnumOption = description: l: mkOption {
    inherit description;
    type = types.enum l;
  };

  mkOfSubmoduleOption = description: of: options: mkOption {
    inherit description;
    type = of (types.submodule {
      inherit options;
    });
  };

  mkSubmoduleOption = description: options: mkOption {
    inherit description;
    type = (types.submodule {
      inherit options;
    });
  };

  mkDisableOption = name: mkOption {
    default = true;
    example = false;
    description = "Whether to enable ${name}";
    type = types.bool;
  };

  mkNullOrStrOption = description: mkOption {
    inherit description;
    type = with types; nullOr str;
  };


  # nixvim helpers

  nv = rec {
    mkMap = (key: action: {
      inherit key action;
      options.silent = true;
    });

    mkMapEx = (key: mode: options: action: (mkMap key action) // {
      inherit mode options;
    });
  };


  # secrets helpers

  # ageOrDefault config "geolocation" "0.00:0.00"
  ageOrDefault = (config: file: content:
    if hasAttr file config.age.secrets
    then config.age.secrets.${file}.path
    else builtins.toFile "agedefault-${file}" content
  );

  ageOrNull = (config: file:
    if hasAttr file config.age.secrets
    then config.age.secrets.${file}.path
    else null
  );

  ageOrBust = (config: file:
    if hasAttr file config.age.secrets
    then config.age.secrets.${file}.path
    else throw "age or bust! age secret required: ${file}"
  );

  loadAgeSecretsFromDir = dir: (
    if pathExists dir then (
      pipe (builtins.readDir dir) [
        (filterAttrs (file: type: (type != "directory") && (hasSuffix ".age" file)))
        (concatMapAttrs (file: _: {
          ${removeSuffix ".age" file}.file = dir + "/${file}";
        }))
      ]
    ) else {}
  );


  # math helpers

  # why on earth do I need to write this myself
  pow = lib.fix (self: base: power:
    if power != 0
    then base * (self base (power - 1))
    else 1
  );


  # other helpers

  # capitalize-dashed-string = Capitalize Dashed String
  # mainly for use with hostnames
  capitalizeDashedString = str: pipe str [
    (splitString "-")
    (map (x: pipe x [
      stringToCharacters
      (imap0 (i: c: if i == 0 then toUpper c else c))
      concatStrings
    ]))
    (lib.concatStringsSep " ")
  ];

  # use at own risk, infinite recursion errors that I couldn't figure out
  mapAttrsRecursiveUpdate = generate: attrset: foldl' (accum: x:
    recursiveUpdate accum (generate x.name x.value)
  ) {} (attrsToList attrset);

  mkIfElse = p: yes: no: mkMerge [
    (mkIf p yes)
    (mkIf (!p) no)
  ];

  mkEachDefault = attrs: pipe attrs [
    attrsToList
    (map (x: if typeOf x.value == "set" then {
      name = x.name;
      value = mkEachDefault x.value;
    } else {
      name = x.name;
      value = mkDefault x.value;
    }))
    listToAttrs
  ];

  myMkOutOfStoreSymlink = (pkgs: path:
    pkgs.runCommandLocal path {} "ln -s ${escapeShellArg path} $out"
  );

  wrapAndAddFlags = package: flags: package.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall or "" + ''
      wrapProgram $out/bin/${oldAttrs.meta.mainProgram} \
        --add-flags "${concatStringsSep " " flags}"
    '';
  });

  wrapWaylandElectron = package: wrapAndAddFlags package [ "--wayland-text-input-version=3" ];

  enumerate = l: foldl' (accum: x: accum ++ [{
    index = length accum;
    value = x;
  }]) [] l;
}
