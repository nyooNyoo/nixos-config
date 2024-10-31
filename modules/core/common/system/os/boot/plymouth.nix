{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optional;

  cfg = config.modules.system.boot.plymouth;
in {
  config = mkIf (cfg.enable) {
    boot.plymouth = {
      enable = true;

      themePackages = optional (cfg.themePackage != null) cfg.themePackage;
      inherit (cfg) theme;
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
