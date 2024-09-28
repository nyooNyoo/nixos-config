{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) any elem optional;

  usr = config.modules.user;
  cfg = config.modules.system.hardware;
in {
  config = mkIf (usr.wm == "sway") {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      extraOptions = [ "--config" "${./config}" ]
        ++ optional (any (type: elem type [ "nvidia" "hybrid-nvidia" ]) cfg.gpu.type) "--unsupported-gpu";
      extraSessionCommands = ''
        export XDG_SESSION_DESKTOP=sway
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      '';
    };
  };
}
