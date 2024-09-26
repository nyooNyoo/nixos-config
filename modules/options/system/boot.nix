{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr str package enum;

in {
  options.modules.system.boot = {

    secureBoot = {
      enable = mkEnableOption "Secure boot.";
    };

    silentBoot = {
      enable = mkEnableOption "Silent boot.";
    };

    loader = mkOption {
      type = enum [ "grub" "systemd-boot" ];
      default = "systemd-boot";
      description = ''
        Which bootloader to use for the device, in general
        you should use systemd-boot for UEFI and grub for legacy boot.
      '';
    };

    plymouth = {
      enable = mkEnableOption "plymouth";

      themePackage = mkOption {
        type = nullOr package;
        default = null;
        description = ''
          Loads a package in which a theme is contained in.
          You only need one, not a list.
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
