{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf mkDefault;

  usr = config.modules.user;
in {

  imports = [
    ./wm

    ./environment.nix
    ./xdg-portals.nix
  ];

  config = mkIf (usr.isWayland) {
    security = {
      polkit.enable = mkDefault true;
      pam.services.swaylock = {};
    };

    programs = {
      dconf.enable = mkDefault true;
      xwayland.enable = mkDefault true;
    };

    services = {
      seatd = {
        enable = mkDefault true;
	group = "wheel";
      };
    };
  };
}
