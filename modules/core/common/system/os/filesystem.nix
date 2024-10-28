{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.lists) elem;

  cfg = config.modules.system.filesystem;
in {
  boot = {
    supportedFilesystems = cfg.enabledFilesystems;
    initrd = {
      supportedFilesystems = cfg.enabledFilesystems;
    };
  };

  environment.etc."lvm/lvm.conf".text = mkIf config.services.lvm.enable ''
    devices {
      issue_discards = 1
    }
  '';

  services = {
    # See option definition
    btrfs.autoScrub = mkIf (elem "btrfs" cfg.enabledFilesystems) {
      inherit (cfg.btrfs.scrub) enable interval;
      fileSystems = cfg.btrfs.scrub.subvolumes;
    };
  };

  systemd.services.fstrim = {
    unitConfig.ConditionACPower = true;
    serviceConfig = {
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };
}
