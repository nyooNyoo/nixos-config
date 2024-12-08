{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix

      # temp testing migration files
      ./security.nix
      ./system.nix
     
      ./firefox
    ];
  
  #wayland.sway.enable = true;  
  environment.systemPackages = with pkgs; 
  [
    R
    rstudio
    (python3.withPackages (ps: with ps; [
      dbus-python
    ]))
    unzip
    openvpn
    logisim
  ];
    
  boot = {
    extraModprobeConfig = ''
      options iwlwifi power_save=1 disable_11ax=1
    '';
  };

  services.fwupd.enable = true;
  services.printing.enable = true;

  modules = {
    system = {
      hardware = {
        cpu.type = "intel";
        gpu.type = [ "intel" "hybrid-nvidia" ];

        tpm.enable = true;
        bluetooth.enable = true;

        yubikey = {
	  #enable = true;
	  cliTools.enable = true;
	};
      };

      boot = {
        plymouth.enable = true;
        silent.enable = true;

        greetd = {
	  enable = true;
          autologin = {
            enable = true;
            user = "nyoo";
          };
        };
      };

      sound = {
        enable = true;

	realtime = {
	  enable = true;
	  soundcardPci = "0000:00:1f.3";
	  rtcqs.enable = true;
	};
      };

      encryption = {
        enable = true;
	rdKeyFiles = true;

        devices.crypted-1 = {
	  keyFile = "/persist/secrets/luks.key";
	  rdKey = true;
	};

        devices.crypted-2 = {
	  keyFile = "/persist/secrets/luks.key";
	  rdKey = true;
	};
      };

      filesystem = {
        enabledFilesystems =
        [
          "vfat"
          "btrfs"
        ];
      };

      display = {
        wm.default = "sway";
	wm.sway.enable = true;
      };
    };
    
    programs = {
      nvim = {
        enable = true;
      };
    };
  };
  
  boot.initrd.secrets = {
    "/secrets/luks.key" = "/persist/secrets/luks.key";
  };

  boot.initrd.luks.devices = {
    crypted-1.keyFile = "/secrets/luks.key";
    crypted-2.keyFile = "/secrets/luks.key";
  };

  system.stateVersion = "24.05";
}

