{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) bool enum;

  usr = config.modules.user;
  cfg = config.modules.system;

in {
  options.modules.user = {
    wm = mkOption {
      type = enum [ "none" "hyprland" "sway" "i3" ];
      default = "none";
      description = ''
        The desktop environment to be used.
      '';
    };

    hyprland = {
      enable = mkEnableOption "Hyprland" // 
        {default = usr.wm == "hyprland";};
      
      package = mkPackageOption pkgs "hyprland" {};
    };

    sway = {
      enable = mkEnableOption "sway" //
        {default = usr.wm == "sway";};

      package = mkPackageOption pkgs "sway" {};
    };

    i3 = {
      enable = mkEnableOption "i3" //
        {default = usr.wm == "i3";};

      package = mkPackageOption pkgs "i3" {};
    };


    isWayland = mkOption {
      type = bool;
      default = (usr.wm.sway.enable || usr.wm.hyprland.enable);
      readOnly = true;
      description = ''
        Whether to enable wayland only packages, environment variables,
        modules, overlays. Also disables all X exclusive packages, variables,
        modules, etc.
      '';
    };
  };
}
