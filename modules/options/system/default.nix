{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
in {
  imports = [
    # options for systems with encrypted disks
    ./encryption.nix
  ];
  options.modules.system = {
    bluetooth = {
      enable = mkEnableOption "bluetooth functionality";
    };
    yubikeySupport = {
      enable = mkEnableOption "yubikey support";
    };
  };
