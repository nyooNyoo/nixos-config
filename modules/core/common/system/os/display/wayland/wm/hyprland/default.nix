{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  usr = config.modules.user;
in {
  config = mkIf (usr.wm.hyprland.enabled or false) {
    # TODO
  };
}
