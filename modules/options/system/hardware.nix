{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr listOf enum str;

  cfg = config.modules.system.hardware;
in {
  options.modules.system.hardware = {

    cpu = {
      type = mkOption {
        type nullOr (enum [ "pi" "intel" "amd" ]);
        default = null;
        description = ''
          The vendor/architecture of the CPU. Always specifiy as it enables needed drivers
          and/or optimizations for that CPU.
        '';
      };
    };

    gpu = {
      type = mkOption {
        type nullOr (listOf (enum [ "pi" "amd" "intel" "nvidia" "hybrid-nvidia" "hybrid-amd" ]));
        default = null;
        description = ''
          The vendor/architecture of the GPU. Determines what drivers and/or modules
          will be loaded for proper video output. In the case of a hybrid system (laptop)
          you can specify multiple GPUs and should include your iGPU and hybrid- for your dGPU.
        '';
      };
      enable = mkEnableOption "Graphics" // {
        default = cfg.gpu != null};
    };

    bluetooth = {
      enable = mkEnableOption "bluetooth";
    };

    sound = {
      enable = mkEnableOption "sound";

      server = mkOption {
        type = enum [ "pipewire" "pulseaudio" ];
        default = "pipewire";
        description = ''
          Determines which sound server the system uses. It is highly reccomended to use
          PipeWire because it better in every way, and is basically required
          for Wayland Compositors.
        '';
      };
    };

    tpm = {
      enable = mkEnableOption "tpm";
    };
  };
}
