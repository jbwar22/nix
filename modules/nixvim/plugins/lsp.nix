{ lib, ... }:

{
  plugins.lsp = {
    enable = true;

    servers = {

      basedpyright = {
        enable = true;
        settings = {
          python = {
            pythonPath = lib.nixvim.mkRaw "vim.fn.exepath(\"python\")";
          };
          basedpyright = {
            analysis = {
              autoSearchPaths = true;
              useLibraryCodeForTypes = true;
              diagnosticMode = "workspace";
              typeCheckingMode = "basic";
              diagnosticSeverityOverrides = {
                reportUnusedImport = "warning";
                reportUnusedClass = "warning";
                reportUnusedVariable = "warning";
                reportUnusedFunction = "warning";
                reportAttributeAccessIssue = "warning";
              };
            };
          };
        };
      };

      nixd = {
        enable = true;
      };

      bashls = {
        enable = true;
      };

      cssls = {
        enable = true;
      };

      yamlls = {
        enable = true;
      };

      jsonls = {
        enable = true;
      };

      jsonnet_ls = {
        enable = true;
      };

    };
  };
}
