{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix

      # temp testing migration files
      ./bootloader.nix
      ./network.nix
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

  modules.system.hardware.gpu.type = [ "intel" "hybrid-nvidia" ];

  system.stateVersion = "24.05";

}

