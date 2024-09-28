{
  imports = [
    ./wm

    ./environment.nix
    ./xdg-portals.nix
  ];

  services.seatd.enable = true;
}
