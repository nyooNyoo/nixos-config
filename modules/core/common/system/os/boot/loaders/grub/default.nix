{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.modules.system.boot.loader;
in {
  config = mkIf (cfg == "grub") {
    boot.loader.grub = {
      enable = true;
      memtest86.enable = true;
      useOSProber = true;
      efiSupport = true;
      # Generate grub boot menu but don't install grub
      device = mkDefault "nodev";
    };
  };
}
