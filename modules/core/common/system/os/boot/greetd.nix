{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.meta) getExe;

  cfg = config.modules.system.boot.greeter;
  usr = config.modules.user;
in {
  config = {
    services.greetd = {
      enable = true;
      
      settings = {
        # default greeter that requires login
        default_session = {
          user = "greeter";
          command = concatStringsSep " " [
            (getExe pkgs.greetd.tuigreet)
            "--time"
            "--remember"
            "--asterisks-char \"-\""
            "--cmd ${cfg.command}"
          ];
        };
 
        # autologin start wm
        initial_session = mkIf cfg.autologin.enable {
          inherit (cfg.autologin) user;
          inherit (cfg) command;
        };
      };
    };
  };
}
