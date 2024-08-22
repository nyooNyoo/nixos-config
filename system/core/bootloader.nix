{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  environment.systemPackages = [
    pkgs.sbctl
  ];
 
  boot = {
    tmp = {
      cleanOnBoot = true;
      useTmpfs = false;
    };

    # Silent boot
    consoleLogLevel = 0;
    plymouth.enable = true; 
    
    initrd = {
      verbose = false;
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      secrets = {
        "/secrets/luks.key" = "/persist/secrets/luks.key";
      };
      
      luks.devices = {
        crypted-1 = {
          preLVM = true;
          fallbackToPassword = true;
          keyFile = "/secrets/luks.key";
        }; 
        crypted-2 = {
          preLVM = true;
          fallbackToPassword = true;
          keyFile = "/secrets/luks.key";
        };
      };
    };
    
    # Bleeding edge linux :)
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "psmouse.synaptics_intertouch=1" # more consistent touchpad behavior
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

    loader = {
      systemd-boot.enable = mkDefault true;
      # spam space to get to boot menu
      timeout = 0;
    };
    loader.efi.canTouchEfiVariables = true;
  };
}
