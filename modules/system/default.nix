{
  imports = [
    ./nix.nix
    # Options and config definition for boot sequence.
    ./boot
    # Options for sound declarations.
    ./sound
    ./hardware.nix

    # Options for systems with encrypted disks.
    ./encryption.nix
    ./filesystem.nix
    ./networking.nix
  ];
}
