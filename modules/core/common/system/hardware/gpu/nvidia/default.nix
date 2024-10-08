{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkDefault mkMerge;
  inherit (lib.strings) versionOlder;
  inherit (lib.lists) elem mutuallyInclusive;

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
  config = mkIf (mutuallyInclusive [ "nvidia" "hybrid-nvidia" ] gpu.type) {
    nixpkgs.config.allowUnfree = true;

    services.xserver = mkMerge [
      {
        videoDrivers = [ "nvidia" ];
      }

      (mkIf (!usr.isWayland) {
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
      systemPackages = with pkgs; [
        nvtopPackages.nvidia

        mesa

        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        libva
        libva-utils
      ];
    };
    hardware = {
      nvidia = {
        package = mkDefault nvidiaPackage;
        modesetting.enable = mkDefault true;
       
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
        extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        extraPackages32 = with pkgs; [ pkgsi686Linux.nvidia-vaapi-driver ];
      };
    };
  };
}
  
