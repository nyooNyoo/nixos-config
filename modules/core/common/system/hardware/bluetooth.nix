{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system.hardware.bluetooth;
in {
  config = mkIf cfg.enable {
    boot.kernelParams = ["btusb"];

    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      powerOnBoot = true;
      # SIM Access Profile
      # 'allows a Bluetooth enabled device to acces data 
      # contained in the SIM card of another Bluetooth device'.
      disabledPlugins = ["sap"];

      # Included in wireplumber
      hsphfpd.enable = !config.services.pipewire.wireplumber.enable;

      settings = {
        General = {
          JustWorksRepairing = "always";
          DiscoverableTimeout = 0;
          Experimental = true;
        }; 
      };
    }; 
    services.blueman.enable = true;
  };
}
