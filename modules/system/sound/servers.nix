{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf mkForce mkOptionDefault;
  inherit (lib.types) enum;

  cfg = config.modules.system.sound.server;
  hasSound = config.modules.system.sound.enable;
in {
  options.modules.system.sound.server = {
    type = mkOption {
      type = enum ["pulseaudio" "pipewire"];
      default = "pipewire";
      description = ''
        Determines your sound server. Pipewire is the newer and more sane option.
	Pulseaudio should only be chosen if forced by hardware compatability.
      '';
    };
  };

  config = let
    isPipewire = (cfg.type == "pipewire");

  in mkIf hasSound {
    hardware.pulseaudio.enable = !isPipewire;

    security.rtkit.enable = if isPipewire then mkForce true else mkOptionDefault false;

    services.pipewire = mkIf isPipewire {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      wireplumber.enable = true;
    };

    systemd.user.services = mkIf isPipewire {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };
}
