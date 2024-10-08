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
    environment.systemPackages = with pkgs; [
      # Yubico's official tools
      yubikey-manager # cli
      yubikey-manager-qt # gui
      yubikey-personalization # cli
      yubikey-personalization-gui # gui
      yubico-piv-tool # cli
      yubioath-flutter # gui
    ];
  };
}
