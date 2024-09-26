{
  pkgs,
  lib,
  ...
}: {
  boot = {
    # silent boot
    initrd = {
      verbose = false;
      kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
      
      luks.devices = {
        crypted-1 = {
          preLVM = true;
          #fallbackToPassword = true;
          keyFile = "/secrets/luks.key";
        }; 
        crypted-2 = {
          preLVM = true;
          #fallbackToPassword = true;
          keyFile = "/secrets/luks.key";
        };
      };
    };
    
    # bleeding edge linux :)
    kernelParams = [
      "splash"
    ];
    extraModprobeConfig = ''
      options iwlwifi power_save=1 disable_11ax=1
    '';

    loader = {
      systemd-boot.enable =  true;
      # spam space to get to boot menu
      timeout = 0;
    };
    loader.efi.canTouchEfiVariables = true;
  };
}
