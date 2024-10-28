{
  config, 
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.lists) optionals;
  inherit (lib.types) listOf str enum;

in {
  options.modules.system.filesystem = {
    enabledFilesystems = mkOption {
      type = listOf str;
      default = ["vfat"];
    };

    btrfs = {
      scrub = {
        enable = mkEnableOption "automatically scrub (error correct) btrfs subvolumes" //
          {default = true;};
        interval = mkOption {
          type = str;
          default = "Sun"; #Sunday
        };
        subvolumes = mkOption {
          type = listOf str;
          default = ["/"];
        };
      };
    };
  };
}
