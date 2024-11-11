{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) int;
in {
  options.modules.system.networking = {
    ssh = {
      # Traps attackers trying to access an open default ssh port
      tarpit = mkEnableOption "Endlessh tarpit" // {default = true;};
      port = mkOption {
        type = int;
        default = 98; #random number
      };
    };
  };
}
