{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault mkForce;
  inherit (lib.lists) singleton;

  cfg = config.modules.system.networking.ssh;
in {
  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      ports = singleton cfg.port;
      
      startWhenNeeded = true;
      settings = {
        PermitRootLogin = "no";

        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";
        ChallengeResponseAuthentication = "no";
        UsePAM = false;

        StreamLocalBindUnlink = "yes";

        KbdInteractiveAuthentication = mkDefault false;
        UseDns = false;
        X11Forwarding = false;

        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "diffie-hellman-group-exchange-sha256"
          "sntrup761x25519-sha512@openssh.com"
        ];

        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];

        ClientAliveCountMax = 5;
        ClientAliveInterval = 60;

        MaxAuthTries = 5;
      };
    };

    endlessh = {
      enable = !cfg.tarpit;
      port = 22;
      openFirewall = true;
      extraOptions = [ "-v" "-s" ];
    };
  };
}
