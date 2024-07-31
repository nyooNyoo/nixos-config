{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    fastfetch
    firefox
    wget
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

}

