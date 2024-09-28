{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  usr = config.modules.user;
  cfg = config.modules.system.hardware;
in {
  config = mkIf (usr.isWayland && cfg.gpu.enable) {
    environment = {
      variables = {
        _JAVA_AWT_WM_NONEREPARENTING = "1";
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland,x11";
        ANKI_WAYLAND = "1";
        MOZ_ENABLE_WAYLAND = "1"; #shouldn't be needed
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";

        # https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md
        WLR_BACKEND = "wayland";
        WLR_RENDERER = "vulkan";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
