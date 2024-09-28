{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  usr = config.modules.user;
  cfg = config.modules.system.hardware;
in {
  # XDG-Portals is not only useful for wayland but I don't have use
  # for it on X11 as of now, this module should be moved to ../xdg-portals
  # if it is later used with X11
  config = mkIf (usr.isWayland && cfg.gpu.enable) {
    xdg.portal = {
      enable = true;
      
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];

      # https://github.com/flatpak/xdg-desktop-portal/blob/main/doc/portals.conf.rst.in
      config = {
        common = let
        portal = 
          if usr.wm == "hyperland"
          then "hyprland"
          else "wlr";
        in {
          default = [ "gtk" ];

          #https://github.com/flameshot-org/flameshot/issues/3363#issuecomment-1753771427
          "org.freedesktop.impl.portal.Screencast" = ["${portal}"];
          "org.freedesktop.impl.portal.Screenshot" = ["${portal}"];
        };
      };
      wlr = {
        enable = true;
        # https://man.archlinux.org/man/extra/xdg-desktop-portal-wlr/xdg-desktop-portal-wlr.5.en
        settings = {
          screencast = {
            max_fps = 30;
            chooser_type = "simple";
            
            chooser_cmd = 
              if usr.wm == "sway"
              then ''${pkgs.sway}/bin/swaymsg -t get_tree |\
                ${pkgs.jq}/bin/jq '.. | select(.pid? and .visible?) | .rect | \"\\(.x),\\(.y) \\(.width)x\\(.height)"' |\
                ${pkgs.slurp}/bin/slurp''
              # TODO add other wm specific ways to select windows
              else "${pkgs.slurp}/bin/slurp -orf %o";
          };
        };
      };
    };
  };
}

