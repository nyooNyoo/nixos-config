{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) bool enum;
  inherit (lib.lists) elem;

  usr = config.modules.user;
in {
  options.modules.user = {
    wm = mkOption {
      type = enum [ "none" "hyprland" "sway" "river" ];
      default = "none";
      description = ''
        The desktop environment to be used.
      '';
    };

    hyprland = {
      package = mkPackageOption pkgs "hyprland" {};
    };

    sway = {
      package = mkPackageOption pkgs "sway" {};
    };

    river = {
      package = mkPackageOption pkgs "river" {};
    };

    isWayland = mkOption {
      type = bool;
      default = (elem usr.wm [ "hyprland" "sway" "river" ]);
      readOnly = true;
      description = ''
        Whether to enable wayland only packages, environment variables,
        modules, overlays. Also disables all X exclusive packages, variables,
        modules, etc.
      '';
    };
  };
}
