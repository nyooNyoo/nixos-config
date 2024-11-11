{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkDefault mkForce;
  inherit (lib.types) enum;

  loader = {
    grub = {
      enable = true;
      useOSProber = mkDefault true;
      efiSupport = mkDefault true;
      device = mkDefault "nodev";
      inherit (cfg) memtest86.enable;
    }; 

    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false
      inherit (cfg) memtest86.enable;
    };
  };

  cfg = config.modules.systemd.boot.loader;
in {
  options.modules.system.boot.loader = {
    type = mkOption {
      type = enum [ "grub" "systemd-boot" ]; 
      default = "systemd-boot";
      description = ''
        Which bootloader to use for the device, in general
	use systemd-boot for UEFI devices and grub for legacy boot.
      '';
    };

    memtest86 = {
      enable = mkEnableOption "memtest86." // {default = true;};
    };
  };

  config.boot.loader = {inherit (loader) ${cfg.type};};
}
