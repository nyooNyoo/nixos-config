{
  config,
  pkgs,
  lib,
  ...
}: let
  ssh = config.modules.system.networking.ssh;
in {
  services.fail2ban = {
    enable = true;
    extraPackages = with pkgs; [nftables];

    ignoreIP = [
      "127.0.0.0/8"
    ];

    maxretry = 5;
    bantime-increment = {
      enable = true;
      rndtime = "10m";
      overalljails = true;
      maxtime = "1000h";
    };

    jails = {
      sshd = {
        settings = {
          enabled = true;
          port = ssh.port; 
        };
      };
    };
  };

  # Ensures fail2ban can see failed auth attempts
  services.openssh.logLevel = "VERBOSE";
}
