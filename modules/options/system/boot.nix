{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr str package enum;
  inherit (lib.attrsets) attrNames attrHead;
  inherit (lib.meta) getExe;

  usr = config.modules.user;

in {
  options.modules.system.boot = {

    secureBoot = {
      enable = mkEnableOption "Secure boot.";
    };

    silentBoot = {
      enable = mkEnableOption "Silent boot.";
    };

    greeter = {
      command = mkOption {
        type = str;
        default = 
          if usr.wm == {} 
          then "${getExe config.users.defaultUserShell}"
          else "${getExe (attrHead usr.wm).package}";
      };
      autologin = {
        enable = mkEnableOption "Autologin to main user.";
        user = mkOption {
          type = enum (attrNames config.users.users);
          default = config.modules.user.mainUser;
          description = ''
            Determines which user is automatically logged in.
          '';
        };
      };
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
