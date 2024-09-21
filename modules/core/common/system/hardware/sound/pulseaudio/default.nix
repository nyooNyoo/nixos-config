{
  config,
  ...
}: let
  inherit (lib.modules) mkIf
  
  cfg = config.modules.system.hardware.sound;
in {
  config = mkIf (cfg.enable && cfg.server == "pulseaudio") {
    hardware.pulseaudio.enable = true;
  };
}
