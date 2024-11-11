{
  imports = [
    # Sane defaults for boot sequence and kernel level config.
    ./boot

    # Defaults for sound servers (conditionally enabled by the sound module).
    ./sound

    # Defaults for nix language and the nix language environment (nixpkgs).
    ./nix

    ./os
  ];
}
