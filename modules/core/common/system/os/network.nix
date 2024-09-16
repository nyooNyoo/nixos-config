{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  environment.systemPackages = with pkgs; [speedtest-cli bandwhich];
  networking = {
    nameservers =
       ["1.1.1.2" "1.1.1.1" "1.0.0.1"];
    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      wifi = {
        macAddress = "random";
        powersave = true;
      };
    };

    firewall = {
      enable = true;
      allowPing = false;
      logReversePathDrops = true;
    };
  };

  virtualisation.docker.enable = true;

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;
}
