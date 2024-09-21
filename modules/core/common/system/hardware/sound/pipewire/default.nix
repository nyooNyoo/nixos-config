{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.modules.system.hardware.sound;
in {
  config = mkIf (cfg.enable && cfg.server == "pipewire") {
    services.pipewire = {
      enable = true;
      
      audio.enable = true;

      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    security.rtkit.enable = true;

    systemd.user.services = {
      pipewire.wantedBy = [ "default.taget" ];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  }; 
}
