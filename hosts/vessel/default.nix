{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix
    ];
  
  #wayland.sway.enable = true;  

  hardware = {
    graphics.enable = true;
    
    nvidia = {
      modesetting.enable = true;

      # turn off gpu when not in use
      powerManagement.enable = true;
      powerManagement.finegrained = true;

      # `nvidia-settings`
      nvidiaSettings = true;
    };
  };

}

