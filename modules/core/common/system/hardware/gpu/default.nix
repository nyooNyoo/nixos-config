{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  gpu = config.modules.system.hardware.gpu;
{
  imports = [
    ./intel
    ./nvidia
    ./amd
  ];  

  config = mkIf gpu.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = [
      glxinfo
      glmark2
    ];
  };
}
