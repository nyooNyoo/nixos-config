{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (builtins) mapAttrs;
  
  cfg = config.modules.system.encryption;
in {
  config = mkIf cfg.enable {
    boot = {
      # faster disk encryption
      initrd.availableKernelModules = [
        "aesni_intel"
        "cryptid"
        "usb_storage"
      ];

      kernelParams = [
        "luks.options=timeout=0"
        "rd.luks.options=timeout=0"

        "rootflags=x-systemd.device-timeout=0"
      ];
    };

    services.lvm.enable = true;
 
    boot.initrd.luks.devices = mapAttrs 
      (_: attr: attr // {
        # improve performance on ssds
        bypassWorkqueues = true;

        # handle LUKS decryption before LVM
        preLVM = true;

        fallbackToPassword = true;
      }) 
    cfg.devices;
  };
}
