lib: with lib; rec {
  # enum helpers

  # definition list of enums
  _enums = {
    os = [ "nixos" "debian" ];
    cpu-vendors = [ "intel" "amd" ];
    gpu-vendors = [ "nvidia" "intel" ];
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
      nameValuePair "${hostname}-${username}" (f hostname username)
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
  filterFromDir = dir: typepredicate: filepredicate: pipe (builtins.readDir dir) [
    (filterAttrs (file: type:
      typepredicate type && filepredicate file
    ))
    (mapAttrsToList (file: _: dir + "/${file}"))
  ];
  getDirsFilter = dir: filepredicate: filterFromDir dir (type: type == "directory") filepredicate;
  getDirs = dir: getDirsFilter dir (_: true);
  getFilesFilter = dir: filepredicate: filterFromDir dir (type: type != "directory") filepredicate;
  getFiles = dir: getFilesFilter dir (_: true);

  getDir = dir: mapAttrs (file: type:
    if type == "directory" then getDir "${dir}/${file}" else type
  ) readDir dir;


  # user helpers

  getAdmins = filterAttrs (_username: user: user.admin);

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

  getHMOpt = config: getter: users: map (username: getter config.home-manager.users.${username}) (attrNames users);

  # set home-manager options for a list of users, with username
  # example: set username for all users
  # home-manager = setHMOptWithUser config.custom.common.opts.host.users (name: { home.username = name; })
  setHMOptWithUserNoPropagate = users: valuef: { users = genAttrs (attrNames users) (name: valuef name); };

  # set home-manager options for a list of users
  # example: enable bash for all users
  # home-manager = setHMOpt config.custom.common.opts.host.users { programs.bash.enable = true; }
  setHMOptNoPropagate = users: value: setHMOptWithUserNoPropagate users (_: value);


  setHMOptWithUser = users: valuef: let
    userAttrs = genAttrs (attrNames users) valuef;
  in {
    home-manager.users = userAttrs;
    custom.nixos.opts.propagated = userAttrs;
  };

  setHMOpt = users: value: setHMOptWithUser users (_: value);


  # set home-manager options for a list of users only if they match a predicate
  # unfortunately this causes infinite recursion and should not be used directly. This was
  # originally built with the purpose of enabling a shell alias for home-manager users with sway
  # enabled on systems with nvidia hardware:
  # home-manager = setHMOptPredicate config users (config:
  #   config.custom.home.program.sway.enable
  # ) {
  #   custom.home.opt.aliases = {
  #     sway = "${pkgs.sway}/bin/sway --unsupported-gpu";
  #   };
  # };
  # however that cause infinite recursion. Instead of doing this, there is a different paradigm that
  # works just as well. Use the common opt structure instead. In the nvidia example that would be
  # just creating a common hardware opt that is true on nvidia hosts. Then reference that only if
  # what would have been the predicate is true.
  # original example: enable vim on users who have bash enabled
  # home-manager = setHMOptPredicate config config.custom.common.opts.host.users (cfg: cfg.programs.bash.enable) { programs.vim.enable = true; }
  _setHMOptPredicate = config: users: predicate: value: { users = genAttrs (filter (username:
    isUserPredicate config username predicate
  ) (attrNames users)) (_: value); };

  # users = setUserGroups config.custom.common.opts.host.users [ "group" ];
  setUserGroups = users: groups: {
    users = mapAttrs (username: user: {
      extraGroups = groups;
    }) users;
  };


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
    
}
