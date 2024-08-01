{ config, pkgs, ... }:

{
  config.home.stateVersion = "24.05"; 
  config.programs.home-manager.enable = true;
  
  imports = [
    ./core
  ];
}
