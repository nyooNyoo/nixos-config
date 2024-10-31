{
  pkgs,
  inputs,
  config,
  ...
}: {
  services = {
    mullvad-vpn.enable = true;

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    logind = {
      lidSwitch = "suspend";
      extraConfig = ''
        HandlePowerKey=suspend
        HibernateDelaySec=3600
      '';
    };

    lorri.enable = true;
    printing.enable = true;
    libinput.enable = true;
    fstrim.enable = true;
  };
}
