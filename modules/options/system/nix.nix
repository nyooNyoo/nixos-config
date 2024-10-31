{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) int str;
  
in {
  options.modules.system.nix = {
    gc = {
      enable = mkEnableOption "Nix garbage colleciton";
      keep = mkOption {
        type = int;
        default = 5;
        description = ''
          Minimum number of generations kept during garbage collection.
        '';
      };
      dates = mkOption {
        type = str;
        default = "Sun";
        description = ''
          systemd.time(7) String specifying when to run gc service.
        ''; 
      };
    };
  };
}
