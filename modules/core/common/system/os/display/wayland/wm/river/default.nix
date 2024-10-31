{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  usr = config.modules.user;
in {
  config = mkIf (usr.wm.river.enabled or false) {
    # TODO
  };
}
