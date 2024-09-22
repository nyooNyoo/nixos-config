{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr str package;

in {
  options.modules.system.boot = {
    silentBoot = {
      enable = mkEnableOption "Silent boot.";
    };

    plymouth = {
      enable = mkEnableOption "plymouth";

      themePackage = mkOption {
        type = nullOr package;
        default = null;
        description = ''
          Loads a package in which a theme is contained in.
          Not a list because you should only have one :).
        '';
      };

      theme = mkOption {
        type = str;
        default = "spinner";
        description = ''
          What plymouth boot splash theme to use.
        '';
      };
    };
  };
}
