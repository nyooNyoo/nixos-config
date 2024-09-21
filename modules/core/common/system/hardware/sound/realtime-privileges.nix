{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.modules.system.hardware.sound;
  usr = config.modules.user;
in {
  # See https://gitlab.archlinux.org/archlinux/packaging/packages/realtime-privileges

  config = mkIf cfg.enable {
    users = {
      users."${usr.mainUser}".extraGroups = [ "audio" ];
      groups.audio = {};
    };

    security.pam.loginLimits = [
      { domain = "@audio";
        type = "-";
        item = "rtprio";
        value = 99;
      }
      { domain = "@audio";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
      { domain = "@audio";
        type = "-";
        item = "nice";
        value = -11;
      }
      # idk what these are :(
      { domain = "@audio";
        type = "soft";
        item = "nofile";
        value = "99999";
      }
      { domain = "@audio";
        type = "hard";
        item = "nofile";
        value = "524288";
      }
    ];

    # Hardware clocks and whatnot
    services.udev.extraRules = ''
      KERNEL=="cpu_dma_latency", GROUP="audio"
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
    '';
  };
}
