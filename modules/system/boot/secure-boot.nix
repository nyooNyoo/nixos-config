{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.meta) getExe;

  cfg = config.modules.system.boot.secureBoot;
in {
  options.modules.system.boot.secureBoot = {
    enable = mkEnableOption "Secrure boot.";

    # TODO More options for TPM encryption
  };

  # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot = {
      systemd.extraBin.sbctl = getExe pkgs.sbctl;
      loader.systemd-boot.enable = mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };
  };
}
