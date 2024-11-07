{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) mutuallyInclusive optional;
  inherit (lib.attrsets) optionalAttrs;

  usr = config.modules.user;
  cfg = config.modules.system.hardware;
in {
  config = mkIf (usr.wm.sway.enable or false) {
    programs.sway = {

      wrapperFeatures.gtk = true;
      package = usr.wm.sway.basePackage;

      extraOptions = [ "--config" "${./config}" ]
        ++ optional (mutuallyInclusive [ "nvidia" "hybrid-nvidia" ] cfg.gpu.type) "--unsupported-gpu";

      extraSessionCommands = ''
        export XDG_SESSION_DESKTOP=sway
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      '';

      extraPackages = mkForce [];
    };

    # Update the package to the wrapped version
    environment = {
      systemPackages = with pkgs; [ 
        swaylock 
	swayidle 
	foot 
	dmenu 
	wmenu 
	brightnessctl
	wl-clipboard
	grim
	slurp
	mako
      ] ++ optional (usr.wm.sway.package != null) usr.wm.sway.package;

      pathsToLink = optional (usr.wm.sway.package != null) "/share/backgrounds/sway";

      etc = {
        "sway/config.d/nixos.conf".source = pkgs.writeText "nixos.conf" ''
          # Import the most important environment variables into the D-Bus and systemd
          # user environments (e.g. required for screen sharing and Pinentry prompts):
          exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
        '';
      } // optionalAttrs (usr.wm.sway.package != null) {
        # Default config to be overriden with --config argument
        "sway/config".source = ./config;
      };
    };
  };
}
