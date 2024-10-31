{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  usr = config.modules.user;
in {
  config = mkIf (usr.isWayland) {
    services.seatd = {
      enable = true;
      group = "wheel";
    };
  };
}
