{
  pkgs,
  inputs,
  config,
  ...
}: {
  services = {
    mullvad-vpn.enable = true;
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "sway";
          user = "nyoo";
        };
        default_session = initial_session;
        terminal.vt = 1;
      };
    };

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
