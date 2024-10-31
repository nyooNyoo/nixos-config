{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault mkForce mkOveride mkIf;
  inherit (lib.lists) optionals optional;

  cfg = config.modules.system.boot;
in {
  imports = [
    ./loaders

    ./plymouth.nix
    ./secure-boot.nix
    ./greetd.nix
  ];

  config.boot = {
    consoleLogLevel = 3;
    # Enable for raid support
    swraid.enable = mkDefault false;

    loader = {
      # If you need to access entries hold space.
      timeout = 0;
      generationsDir.copyKernels = true;
      efi.canTouchEfiVariables = true;
    };

    tmp = {
      # Uses ram instead of disk space
      useTmpfs = mkDefault true;
      cleanOnBoot = (!config.boot.tmp.useTmpfs);
    };

    initrd = {
      verbose = false;

      systemd = {
        # needed to support tpm decryption
        enable = true;

        # some emergency tooling
        storePaths = with pkgs; [ util-linux cryptsetup sbctl ];
        extraBin = {
          sbctl = "${pkgs.sbctl}/bin/sbctl";
          fdisk = "${pkgs.util-linux}/bin/fdisk";
          lsblk = "${pkgs.util-linux}/bin/lsblk";
          cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
        };
      };

      kernelModules = [
        "btrfs"
        "nvme"
        "tpm"
        "sd_mod"
        "dm_mod"
        "ahci"
        "vfat"
      ];
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "pti=auto"
      # CPU idle
      # https://www.kernel.org/doc/html/v5.0/admin-guide/pm/cpuidle.html
      # poll ; actually a net negative
      # halt ; calls HLT
      # nomwait ; use acpi_idle driver
      "idle=nowait"
      
      # Virtualization passthrough
      "iommu=pt"

      # This is only for hibernation, which is a huge pain
      "noresume"

      "acpi_backlight=native"

      # Helps plymouth
      "fbcon=nodefer"

      "vt.global_cursor_default=0"

      "logo.nologo"

      "boot.shell_on_fail"
    ] ++
    (optionals cfg.silentBoot.enable [
      "quiet"
      # Only show errors or worse.
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"

      # disable systemd messages
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
    ]);
  };
}
