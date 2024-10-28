{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;
in {
  imports = [
    #./firewall
    
    #./network-manager.nix
    ./ssh.nix
  ];

  # Helpful networking tools
  environment.systemPackages = with pkgs; [
    speedtest-cli
    bandwhich
  ];

  networking = {
    # Depreciated
    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    nameservers = [
      # Cloudflare
      # https://developers.cloudflare.com/1.1.1.1/ip-addresses/
      "1.1.1.2" "2606:4700:4700::1112"
      "1.0.0.2" "2606:4700:4700::1002"

      # Quad9
      # https://www.quad9.net/service/service-addresses-and-features/
      "9.9.9.9" "2620:fe::9"
      "149.112.112.112" "2620:fe::fe"
    ];

    # Allows some shorthand to access hosts
    search = [
      "nyoo.dev."
    ];
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

  systemd = {
    # Safe to remove when handled by network manager.
    network.wait-online.enable = false;
    services = {
      # This is safe to disable and improves boot time.
      NetworkManager-wait-online.enable = false;
    };
  };
}
