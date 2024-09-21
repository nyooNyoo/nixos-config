{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem any;
  inherit (lib) mkIf mkDefault mkMerge versionOlder;

  nvStable = config.boot.kernelPackages.nvidiaPackages.stable;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta;

  nvidiaPackage = 
    if (versionOlder nvBeta.version nvStable.version)
    then nvStable
    else nvBeta;

    gpu = config.modules.system.hardware.gpu;
    usr = config.modules.user;

    isHybrid = elem "hybrid-nvidia" gpu.type;
in {
  config = mkIf (any (type: elem type [ "nvidia" "hybrid-nvidia" ]) gpu.type) {
    nixpkgs.config.allowUnfree = true;

    services.xserver = mkMerge [
      {
        videoDrivers = [ "nvidia" ];
      }

      (mkIf (!cfg.isWayland) {
        # disable DPMS - Display Power Managment Signaling
        monitorSection = ''
          Option "DPMS" "false"
        '';

       # disable other screen blanking
       serverFlagsSection = ''
         Option "StandbyTime" "0"
         Option "SuspendTime" "0"
         Option "OffTime" "0"
         Option "BlankTime" "0"
       '';
      })
    ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    environment = {
      sessionVariables = mkMerge [
        {LIBVA_DRIVER_NAME = "nvidia";}
    
        (mkIf usr.isWayland {
          WLR_NO_HARDWARE_CURSORS = "1";
        })
      ];
      systemPackages = [
        pkgs.nvtopPackages.nvidia

        pkgs.mesa

        pkgs.vulkan-tools
        pkgs.vulkan-loader
        pkgs.vulkan-validation-layers
        pkgs.vulkan-extension-layer

        pkgs.libva
        pkgs.libva-utils
      ];
    };
    hardware = {
      nvidia = {
        package = mkDefault nvidiaPackage;
        modesettings.enable = mkDefault true;
       
        prime.offload = {
          enable = isHybrid;
          enableOffloadCmd = isHybrid;
        };

        powerManagement = {
         enable = mkDefault true;
         finegrained = mkDefault isHybrid;
        };

        open = mkDefault true;
        nvidiaSettings = false;
	# Persistenced is only relevant for server systems to my understanding
	# and has a negative impact on power consumption
        # nvidiaPersistenced = true;
        
        # Possible slow downs
        # forceFullCompositionPipeline = true;
    };
  
    graphics = {
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
      extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
    };
  };
}
  
