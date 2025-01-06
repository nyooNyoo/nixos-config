{ config, lib, pkgs, packages, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix

      # temp testing migration files
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
        plymouth = {
	  enable = true;
	  themePackage = packages.plymouth-copland-theme;
	};

        silent.enable = true;
	secureBoot.enable = true;

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
	  #rtcqs.enable = true;
	};
      };

      encryption = {
        enable = true;

        devices.crypted-1 = {
	  keyFile = {
	    enable = true;
	    rdKey = true;
	    file = "/persist/secrets/luks.key";
	  };
	};

        devices.crypted-2 = {
	  keyFile = {
	    enable = true;
	    rdKey = true;
	    file = "/persist/secrets/luks.key";
	  };
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
  
  system.stateVersion = "24.05";
}

