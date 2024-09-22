{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

in {
  imports = [
    # options for systems with encrypted disks
    ./encryption.nix

    ./hardware.nix

    ./boot.nix
  ];
}
