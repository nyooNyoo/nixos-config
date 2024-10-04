{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) mutuallyInclusive optional;

  usr = config.modules.user;
  cfg = config.modules.system.hardware;
in {
  config = mkIf (usr.wm == "sway") {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      package = usr.sway.package;

      extraOptions = [ "--config" "${./config}" ]
        ++ optional (mutuallyInclusive [ "nvidia" "hybrid-nvidia" ] cfg.gpu.type) "--unsupported-gpu";

      extraSessionCommands = ''
        export XDG_SESSION_DESKTOP=sway
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      '';
    };
  };
}
