{ config, pkgs, inputs, ... }:

{
  config.home.stateVersion = "24.05"; 
  config.programs.home-manager.enable = true;
  
  imports = [
    inputs.schizofox.homeManagerModule
    ./core
  ];
}
