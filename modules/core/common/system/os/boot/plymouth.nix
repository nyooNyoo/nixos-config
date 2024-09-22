{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;

  cfg = config.modules.system.boot.plymouth;
in {
  config = mkIf cfg.enable {
    boot.plymouth = {
      enable = true;

      # I think this can be cleaned up
      themePackages = mkIf (cfg.themePackage != null) singleton cfg.themePackage;
      inherit cfg.theme;
    };

    powerManagement = {
      powerDownCommands = ''
        ${pkgs.plymouth} --show-splash
      '';
      resumeCommands = ''
        ${pkgs.plymouth} --quit
      '';
    };
  };
}
