{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem any;
  inherit (lib.modules) mkIf;
  
  gpu = config.modules.system.hardware.gpu;
in {
  config = mkIf (gpu.type != null && elem "intel" gpu.type) {
    boot.initrd.kernelModules = [ "i915" ];

    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      extraPackages = [
        pkgs.intel-vaapi-driver
        pkgs.libva-vdpau-driver
        pkgs.intel-compute-runtime
        pkgs.intel-media-driver
        pkgs.libvdpau-va-gl
      ];

      /*extraPackages32 = [
        pkgs.pkgs1686Linux.vaapiIntel
        pkgs.pkgs1686Linux.vaapiVdpau
        pkgs.pkgs1686Linux.intel-media-driver
        pkgs.pkgs1686Linux.libvdpau-va-gl
      ];*/
    };

    environment.variables = mkIf (any (type: elem type [ "hybrid-amd" "hybrid-nvidia" ]) gpu.type) {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
