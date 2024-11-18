{lib, ...}: let
  inherit (lib.modules) mkDefault;
  inherit (lib.strings) readFile;

in {
  config.modules.system.display.wm.sway = {
    config = mkDefault (readFile ./config);
  };
}
