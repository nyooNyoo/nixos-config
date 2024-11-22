{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;

in {
  imports = [
    # Firewall options.
    ./firewall.nix

    # SSH server options.
    ./ssh.nix
  ];

  options.modules.system.networking = {
    enable = mkEnableOption "Networking." // {default = true;};
  };
}
