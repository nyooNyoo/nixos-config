{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr listOf enum str;
in {
  options.modules.system.hardware = {

    cpu = {
      type = mkOption {
        type nullOr (enum [ "pi" "intel" "amd" ]);
        default = null;
        description = "CPU vendor/architecture.";
      };
    };

    gpu = {
      type = mkOption {
        type nullOr (listOf (enum [ "pi" "amd" "intel" "nvidia" "hybrid-nvidia" "hybrid-amd" ]))
        default = null;
        description = ''
          The vendor/architecture of the GPU. Determines what drivers and/or modules
          will be loaded for proper video output.
        '';
      };
    };
