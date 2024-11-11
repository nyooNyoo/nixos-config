{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) listOf nullOr path package;

in {
  options.modules.user.programs.nvim = {
    enable = mkEnableOption "Neovim text editor"; 

    viAlias = mkEnableOption "Neovim symlink over vi" // {default = true;};
    vimAlias = mkEnableOption "Neovim symlink over vim"// {default = true;};
    
    initRc = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        File loaded as the init.lua file on startup. This should
        always be in the nix store unless you're stupid.
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
}
