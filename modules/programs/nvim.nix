{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) listOf nullOr path package;
  inherit (lib.lists) map optionals;

  cfg = config.modules.programs.nvim;
in {
  options.modules.programs.nvim = {
    enable = mkEnableOption "Neovim text editor"; 

    package = mkPackageOption pkgs "neovim" {
      default = "neovim-unwrapped";
    } // {apply = p: pkgs.wrapNeovimUnstable p {
      inherit (cfg) viAlias vimAlias;

      wrapRc = false;
      wrapperArgs = optionals (cfg.initRc != null) [ "--add-flags" "-u ${cfg.initRc}" ];
      plugins = let
        # idk if packages work here yet. Might need to get the package name string.
        formatPlugins = opt: map (x: {plugin = x; config = ""; optional = opt;});
      in (formatPlugins true cfg.startPlugins) ++ (formatPlugins false cfg.optPlugins);
      };
    };

    viAlias = mkEnableOption "Neovim symlink over vi" // {default = true;};
    vimAlias = mkEnableOption "Neovim symlink over vim"// {default = true;};
    
    initRc = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        File loaded as the init.lua file on startup. 
      '';
    };

    startPlugins = mkOption {
      type = listOf package;
      default = [];
      description = ''
        Plugins which are loaded at launch.
      '';
    };

    optPlugins = mkOption {
      type = listOf package;
      default = [];
      description = ''
        Plugins which are loaded upon invocation within nvim.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      # TODO, make option
      variables.EDITOR = "nvim";
      pathsToLink = ["/share/nvim"];
      systemPackages = [cfg.package];
    };
  };
}
