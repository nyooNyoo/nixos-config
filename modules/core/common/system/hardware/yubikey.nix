{
  config,
  pkgs,
  lib, 
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.modules.system.hardware.yubikeySupport;
in {
  config = mkIf cfg.enable {
    hardware.gpgSmartcards.enable = true;

    services = {
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };

    programs = {
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    environment.systemPackages = [
      # Yubico's official tools
      pkgs.yubikey-manager # cli
      pkgs.yubikey-manager-qt # gui
      pkgs.yubikey-personalization # cli
      pkgs.yubikey-personalization-gui # gui
      pkgs.yubico-piv-tool # cli
      pkgs.yubioath-flutter # gui
    ];
  };
}
