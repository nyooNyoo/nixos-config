{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkDefault;
  inherit (lib.types) int;

  cfg = config.modules.system.networking.ssh;
in {
  options.modules.system.networking.ssh = {
    enable = mkEnableOption "Secure Shell.";

    forceKey = mkEnableOption "Authentication forced through ssh key." // {
      default = true;
    };

    # Traps attackers trying to access an open default ssh port
    tarpit = {
      enable = mkEnableOption "Endlessh tarpit" // {default = (cfg.port != 22);};
    };

    port = mkOption {
      type = int;
      default = 30;
    };
  };

  config = mkIf cfg.enable {
    # For helpful security diagnostics run
    # nix-shell -p ssh-audit --command "ssh-audit localhost:30"
    services = {
      openssh = {
        enable = true;
	openFirewall = true;
	ports = [cfg.port];

	startWhenNeeded = mkDefault true;

        settings = {
	  PermitRootLogin = mkDefault "no"; 
	  PasswordAuthentication = !cfg.forceKey;
	  ChallengeResponseAuthentication = mkDefault "no";
	  PerSourceMaxStartups = "1";
	  UsePAM = !cfg.forceKey;

          KbdInteractiveAuthentication = !cfg.forceKey;
	  UseDns = false;
	  X11Forwarding = false;

	  KexAlgorithms = [
	    
	  ];

	  Ciphers = [
	    "aes256-gcn@openssh.com"
	    "aes128-gcm@openssh.com"
	    "aes256-ctr"
	    "aes192-ctr"
	    "aes128-ctr"
	  ];
	};
      };
    };
  };
}
