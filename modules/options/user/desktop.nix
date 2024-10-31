{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) bool str attrsOf submodule;
  inherit (lib.lists) mutuallyInclusive length;
  inherit (lib.attrsets) attrNames;

  usr = config.modules.user;
in {
  options.modules.user = {
    wm = mkOption {
      default = {};
      type = attrsOf (submodule (
        {name, ...}: {
          options = {
            # Prioritize package set in config.programs.$name.package for
            # cases like sway which expose wrapper options this way (saves myself from duplicate options)
            package = mkPackageOption pkgs name {} // {default = config.programs."${name}".package or name;};
            enable = mkEnableOption "${name} window manager." // {default = true;};
          };
        }
      ));
    };

    isWayland = mkOption {
      type = bool;
      # (non-exhaustive)
      # TODO: check against shared override argument such as XWayland
      default = (mutuallyInclusive (attrNames usr.wm) [ "hyprland" "sway" "river" ]);
      readOnly = true;
      description = ''
        Whether to enable wayland only packages, environment variables,
        modules, overlays. Also disables all X exclusive packages, variables,
        modules, etc.
      '';
    };
  };

  config.warnings =
    if usr.wm == {}
    then [''
            You have no window manager enabled, you will not boot
            into a graphical environment. You must ensure all options
            are correctly set.
          '']
    else if length (attrNames usr.wm) > 1
    then [''
            You have more than one window manager enabled, this should only
            be the case if you know what you're doing and have checked
            that all options will not conflict.
          '']
    else [];
}
