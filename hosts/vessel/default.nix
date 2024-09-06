{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./disk-config.nix
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

      # `nvidia-settings`
      nvidiaSettings = true;
    };
  };

}

