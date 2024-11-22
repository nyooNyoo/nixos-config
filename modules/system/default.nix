{
  imports = [
    # Options and config definition for boot sequence.
    ./boot

    # Options for graphical interfaces
    ./display

    # Options for systems with encrypted disks.
    ./encryption.nix

    # Options to enable filesystem modules and filesystem exclusive features
    ./filesystem.nix

    # Options to set hardware specifications and capabilities
    ./hardware

    # Options for network capapbilities and security
    ./networking

    # Options for sound declarations.
    ./sound
  ];
}
