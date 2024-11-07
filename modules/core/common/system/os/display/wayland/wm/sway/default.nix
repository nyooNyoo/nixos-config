{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) mutuallyInclusive optional;

  usr = config.modules.user;
  cfg = config.modules.system.hardware;
in {
  config = mkIf (true) {
    programs.sway = {
      enable = true;
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
    modules.user.wm.sway.package = config.programs.sway.package;

    environment = {
      systemPackages = with pkgs; [ swaylock swayidle foot dmenu wmenu ];
    };
  };
}
