{
  pkgs,
  inputs,
  myLib,
  lib,
  ...
}: let 
  test = (myLib.dirsIn ./.);

  in { 
  imports = [
    ./fonts.nix
    ./services.nix
    ./pipewire.nix
    ./sway
  ] ++ test;  

  

  environment = {
    variables = {
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      DISABLE_QT5_COMPAT = "0";
      ANKI_WAYLAND = "1";
      DIRENV_LOG_FORMAT = "";
      WLR_DRM_NO_ATOMIC = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      DISABLE_QT_COMPAT = "0";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      MOZ_ENABLE_WAYLAND = "1";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_CACHE_HOME = "/home/nyoo/.cache";
      CLUTTER_BACKEND = "wayland";
    };
    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
      eval $(gnome-keyring-daemon --start --components=ssh,secrets)
      eval $(ssh-agent)
    '';
    systemPackages = with pkgs; [
      pamixer
      grim
      slurp
      mako
      brightnessctl
      wl-clipboard
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

}
