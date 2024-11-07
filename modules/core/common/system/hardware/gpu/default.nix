{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  gpu = config.modules.system.hardware.gpu;
in {
  imports = [
    ./intel
    ./nvidia
    ./amd
  ];  

  config = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = [
      pkgs.glxinfo
      pkgs.glmark2
    ];
  };
}
