{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.writers) writeText;
  inherit (lib.strings) readFile;

  cfg = config.modules.system.display.wm.sway or {};
  isNvidia = mutuallyInclusive ["nvidia" "hybrid-nvidia"] config.modules.system.hardware.gpu.type
  configFile = writeText "sway-config" ''
    ${readFile cfg.configFile}
  '';

in mkIf (cfg.enable or false) {
  cfg.configFile = mkOptionDefault ./config;

  config = {
    programs.sway = {

      wrapperFeatures.gtk = mkOptionDefault true;

      extraOptions = ["--config" "${configFile}"]
      optional isNvidia "--unsupported-gpu"

      extraSessionCommands = ''
        export XDG_SESSION_DESKTOP=sway
	export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      '';
    };

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
      ];
      
      etc = {
        "sway/config.d/nixos.conf".source = writeText "nixos.conf" ''
	  exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
	'';
      };
    };
  };
}
