{
  config,
  lib,
  pkgs,
  ...
}: let
  # Warning: I do not have a system that uses a amd gpu yet
  # there is no guarentee these are good defaults so use
  # at your own risk.

  inherit (builtins) elem any;
  inherit (lib) mkIf mkDefault;
  
  gpu = config.modules.system.hardware.gpu;
in {
  config = mkIf (any (type: elem type [ "amd" "hybrid-amd" ]) gpu.type) {
    services.xserver.videoDrivers = mkDefault [ "modesetting" "amdgpu" ];

    boot = {
      initrd.kernelModules = [ "amdgpu" ];
      kernelModules = [ "amdgpu" ];
    };
 
    environment.systemPackages = [ plgs.nvtopPackages.amd ];

    hardware.graphics = {
      extraPackages = [
        pkgs.amdvlk
        
        pkgs.mesa
 
        pkgs.vulkan-tools
        pkgs.vulkan-loader
        pkgs.vulkan-validation-layers
        pkgs.vulkan-extension-layer

        pkgs.rocmPackages.clr
        pkgs.rocmPackaes.clr.icd
      ];

      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };
}
