{
  options,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) bool str attrsOf submodule;
  inherit (lib.lists) mutuallyInclusive filter length;
  inherit (lib.attrsets) attrNames;
  inherit (lib.trivial) throwIf;
  inherit (lib.strings) concatStringsSep;

  usr = config.modules.user;
in {
  options.modules.user = {
    wm = mkOption {
      default = {};
      type = attrsOf (submodule (
        {name, ...}: {
          options = {
	    # Because wrappers work however they want this is the only solution
	    # I could come up with to solve my delema of needing both a generalized
	    # option for packages to be wrapped as well as needing a generalized reference
	    # to the wrapped package.
	    basePackage = mkPackageOption pkgs name {};
            package = mkPackageOption pkgs name {} // {
	      default = usr.wm.${name}.basePackage;
	      apply = p: let 
	        defs = filter (x: x.value ? ${name}.package) options.modules.user.wm.definitionsWithLocations;
	      in throwIf (length defs > 1) ''
The option 'modules.user.wm.${name}.package' is defined outside of internal wrapper.

Definitions values:
${concatStringsSep "\n" (map (x: "- In " + x.file) defs)}
	      '' p;
	    };
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
