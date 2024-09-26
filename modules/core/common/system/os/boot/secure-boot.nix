{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;

  cfg = config.modules.system.boot.secureBoot;
in {

  # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot.loader.systemd-boot.enable = mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
