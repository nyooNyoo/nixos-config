{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];
 
  boot = {
    tmp = {
      cleanOnBoot = true;
      useTmpfs = false;
    };

    # Silent boot
    consoleLogLevel = mkDefault 0;
    plymouth.enable = true; 
    
    initrd = {
      verbose = false;
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      luks.yubikeySupport = true;
      
      # https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS#NixOS_installation
      luks.devices = {
        "nixos-enc" = {
          device = "/dev/disk/by-uuid/df0d8f1e-6b1a-436e-97cc-dd8410cfe2d9";
          preLVM = true;
          yubikey = {
            slot = 2;
            gracePeriod = 999;
            twoFactor = false;
            storage = {
              device = "/dev/disk/by-uuid/3382-5527";
            };
          };
        };
      };
    };
    
    # Bleeding edge linux :)
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    kernelParams = [
      "psmouse.synaptics_intertouch=1" #more consistent touchpad behavior
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    extraModprobeConfig = ''
      options i915 enable_guc=2
      options iwlwifi power_save=1 disable_11ax=1
    '';
    #https://wiki.archlinux.org/title/Intel_graphics#Enable_GuC_/_HuC_firmware_loading

    bootspec.enable = mkDefault true;
    loader = {
      systemd-boot.enable = mkDefault true;
      # spam space to get to boot menu
      timeout = 0;
    };
    loader.efi.canTouchEfiVariables = true;
  };
}
