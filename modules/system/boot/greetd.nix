{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.attrsets) attrHead;
  inherit (lib.meta) getExe;

  cfg = config.modules.system.boot.greetd;
  usr = config.modules.user;
in {
  options.modules.system.boot.greetd = {
    enable = mkEnableOption "greetd.";

    package = mkPackageOption pkgs.greetd "greetd" {
      default = "tuigreet";
    };

    command = mkOption {
      type = str;
      default = 
        if usr.wm == {}
	then "${getExe config.users.defaultUserShell}"
	else "${getExe (attrHead usr.wm).package}";
      description = ''
        Command executed by the greeter upon login / autologin.
      '';
    };

    greeterArgs = mkOption {
      type = listOf str;
      default = [
      "--time"
      "--remember"
      "--asterisks-char" "\"-\""
      ];
      description = ''
        Command line arguments applied to the greeter.
      '';
    };

    autologin = {
      enable = mkEnableOption "Autologin.";

      user = mkOption {
        type = enum (attrNames config.users.users);
	default = usr.mainUser;
	description = ''
	  Determines which user is automatically logged in.
	'';
      };
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      vt = 1;
      
      settings = {
        # default greeter that requires login
        default_session = {
          user = "greeter";
          command = concatStringsSep " " ([
            (getExe cfg.package)
            "--cmd ${cfg.command}"
          ] ++ cfg.greeterArgs);
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
