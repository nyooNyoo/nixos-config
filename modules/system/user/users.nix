{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;

in {
  options.modules.user = {
    mainUser = mkOption {
      type = str;
      default = "nyoo";
      description = ''
        Primary user of the machine, will be given all rights.
        Other users may have to be added to groups to be given
        more control.
      '';
    };
  };
}
