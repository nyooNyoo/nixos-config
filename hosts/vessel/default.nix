{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix

      # temp testing migration files
      ./bootloader.nix
      ./security.nix
      ./users.nix
      ./system.nix
     
      ./wayland
      ./firefox
    ];
  
  #wayland.sway.enable = true;  
  environment.systemPackages = with pkgs; 
  [
    R
    rstudio
    (python3.withPackages ( ps: with ps; [
      dbus-python
    ]))
    unzip
    openvpn
    openvpn3
    winetricks
    wineWowPackages.waylandFull
  ];

  hardware = {
    graphics.enable = true;
    
    nvidia = {
      modesetting.enable = true;

      # turn off gpu when not in use
      powerManagement.enable = true;
      powerManagement.finegrained = true;
    };
  };

  services.fwupd.enable = true;
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  modules = {
    system = {
      hardware = {
        cpu.type = "intel";
        gpu.type = [ "intel" "hybrid-nvidia" ];

        bluetooth.enable = true;
        yubikeySupport.enable = true;
        sound.enable = true;
      };

      boot = {
        plymouth.enable = true;
        silentBoot.enable = true;
      };

      encryption = {
        enable = true;
 
        devices.crypted-1.keyFile = "/secrets/luks.key";
        devices.crypted-2.keyFile = "/secrets/luks.key";
      };

      filesystem = {
        enabledFilesystems =
        [
          "vfat"
          "btrfs"
        ];
      };
    };
    
    user = {
      wm = "sway";
      mainUser = "nyoo";
    };
  };
  
  boot.initrd.secrets = {
    "/secrets/luks.key" = "/persist/secrets/luks.key";
  };

  

  system.stateVersion = "24.05";
}

