{
  config, 
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.lists) optionals elem;
  inherit (lib.types) listOf str enum;

  cfg = config.modules.system.filesystem;
in {
  options.modules.system.filesystem = {
    enabledFilesystems = mkOption {
      type = listOf str;
      default = ["vfat"];
    };

    btrfs = {
      scrub = {
        enable = mkEnableOption "automatically scrub (error correct) btrfs subvolumes" // {
	  default = elem "btrfs" cfg.enabledFilesystems;};
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

  config = {
    boot = {
      supportedFilesystems = cfg.enabledFilesystems;
      initrd.supportedFilesystems = cfg.enabledFilesystems;
    };

    services = {
      btrfs.autoScrub = mkIf (elem "btrfs" cfg.enabledFilesystems) {
        inherit (cfg.btrfs.scrub) enable interval;
	fileSystems = cfg.btrfs.scrub.subvolumes;
      };
    };

    systemd.services.fstrim = {
      unitConfig.ConditionACPower = true;
      serviceConfig = {
        Nice = 19;
	IOScedulingClass = "idle";
      };
    };

    warnings = 
      if (cfg.enabledFilesystems == [])
      then [''
        There are no filesystems configured, this may cause issues mounting and accessing.
      '']
      else if !(elem "vfat" cfg.enabledFilesystems)
      then [''
        'vfat' is not included in enabled filsystems (commonly the boot partition).
      '']
      else [];
  };
}
