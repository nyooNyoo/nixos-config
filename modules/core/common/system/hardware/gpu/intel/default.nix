{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) elem mutuallyInclusive;
  
  gpu = config.modules.system.hardware.gpu;
in {
  config = mkIf (elem "intel" gpu.type) {
    boot.initrd.kernelModules = [ "i915" ];

    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libva-vdpau-driver
        intel-compute-runtime
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    environment.variables = mkIf (mutuallyInclusive [ "hybrid-amd" "hybrid-nvidia" ] gpu.type) {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
