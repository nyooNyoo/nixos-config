{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem any;
  inherit (lib.modules) mkIf;
  
  cfg = config.modules.system.hardware.gpu;

in {
  config = mkIf (elem "intel" cfg.type) {
    boot.initrd.kernelModules = [ "i915" ];

    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      extraPackages = [
        pkgs.vaapiIntel
        pkgs.vaapiVdpau
        pkgs.intel-compute-runtime
        pkgs.intel-media-driver
        pkgs.libvdpau-va-gl
      ];

      extraPackages32 = [
        pkgs.pkgs1686Linux.vaapiIntel
        pkgs.pkgs1686Linux.vaapiVdpau
        pkgs.pkgs1686Linux.intel-media-driver
        pkgs.pkgs1686Linux.libvdpau-va-gl
      ];
    };

    environment.variables = mkIf (any (type: elem type [ "hybrid-amd" "hybrid-nvidia" ]) cfg.gpu.type {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
