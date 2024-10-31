{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

in {
  imports = [
    ./nix.nix
    ./boot.nix
    ./hardware.nix
    # options for systems with encrypted disks
    ./encryption.nix
    ./filesystem.nix
    ./networking.nix
  ];
}
