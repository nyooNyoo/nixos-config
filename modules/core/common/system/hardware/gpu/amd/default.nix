{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.lists) mutuallyInclusive;
  
  gpu = config.modules.system.hardware.gpu;
in {
  config = mkIf (mutuallyInclusive [ "amd" "hybrid-amd" ] gpu.type) {
    services.xserver.videoDrivers = mkDefault [ "modesetting" "amdgpu" ];

    boot = {
      initrd.kernelModules = [ "amdgpu" ];
      kernelModules = [ "amdgpu" ];
    };
 
    environment.systemPackages = with pkgs; [ nvtopPackages.amd ];

    hardware.graphics = {
      extraPackages = with pkgs; [
        amdvlk
        
        mesa
 
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        rocmPackages.clr
        rocmPackaes.clr.icd
      ];

      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
  };
}
