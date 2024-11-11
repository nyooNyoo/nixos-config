{
  options,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf mkMerge mkDefault mkDefaultAttr mkOptionDefault;
  inherit (lib.types) bool str attrsOf submodule;
  inherit (lib.attrsets) attrNames mapAttrsToList;
  inherit (lib.lists) mutuallyInclusive optional;
  inherit (lib.meta) getExe;

  cfg = config.modules.system.display;
in {
  imports = [
    # Import specific wrapper stuff for implemented wms.
    ./wms
  ];

  options.modules.system.display = {
    wm = mkOption {
      default = {};
      type = attrsOf (submodule (
        {name, ...}: {
          options = {
	    # Inherit the wrapper from most wm definitions (at least wayland ones).
            package = mkPackageOption pkgs name {} // {
	      apply = options.programs.${name}.package.apply or (p: p);
	    };
            enable = mkEnableOption "${name} window manager." // {default = true;};
	    configFile = mkOption {
	      type = path;
	      default = ./wms/${name}/config
	      description = ''
	        Points to config file for the window manager if supported by the wrapper.
	      '';
	    };
          };
        }
      ));
    };

    isWayland = mkOption {
      type = bool;
      # (non-exhaustive)
      # TODO: find better solution
      # move this to inside the wm
      default = (mutuallyInclusive (attrNames usr.wm) [ "hyprland" "sway" "river" ]);
      readOnly = true;
      description = ''
        Whether to enable wayland only packages, environment variables,
        modules, overlays. Also disables all X exclusive packages, variables,
        modules, etc.
      '';
    };
  };

  config = mkIf config.hardware.graphics.enable (mkMerge [{
    warnings = optional (length (attrNames cfg.wm) > 1) ''
      You have more then one window manager enabled, this may break
      functionality if you have not ensured options handle this correctly.
    '';

    environment.systemPackages = mapAttrsToList (_: x: x.package) cfg.wm;
  }

  (mkIf cfg.isWayland {
    security = {
      polkit.enable = mkDefault true;
      pam.services.swaylock = {};
    };

    programs = {
      dconf.enable = mkDefault true;
      xwayland.enable = mkDefault true;
    };

    services = {
      seatd = {
        enable = mkDefault true;
	group = "wheel";
      };
    };
    
    # TODO wrap specifically wayland wms with these
    environment.variables = mkDefaultAttr {
      _JAVA_AWT_WM_NONEREPARENTING = "1";
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland,x11";
      ANKI_WAYLAND = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";

      WLR_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];

      config = {
        common = let
	  portal = if (cfg.wm.hyprland.enable or false)
	    then "hyprland"
	    else "wlr";
	in {
	  default = ["gtk"];
	  "org.freedesktop.impl.portal.Screencast" = ["${portal}"];
	  "org.freedesktop.impl.portal.Screenshot" = ["${portal}"];
	};
      };

      wlr = {
        enable = true;

	settings = {
	  screencast = {
	    max_fps = 30;
	    chooser_type = "simple";
	    chooser_cmd = mkOptionDefault ("${getExe pkgs.slurp} -orf %o");
	  };
	};
      };
    };
  })

  (mkIf !cfg.isWayland {
    warnings = optional (cfg.wm == {}) ''
      You have no window manager enabled, you will not boot
      into a graphical environment.
    ''
  })]);
}
