{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  
  cfg = config.modules.system.boot.loader;
in {
  config = mkIf (cfg == "systemd-boot") {
    boot.loader.systemd-boot = {
      enable = true;
      memtest86.enable = true;

      # Should be handled by gc.
      # configurationLimit = 20;

      # Obviously we need high def bootloader
      consoleMode = "max";

      editor = false;
    };
  };
}
