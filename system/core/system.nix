{
  pkgs,
  lib,
  ...
}: {
  services = {
    dbus = {
      packages = with pkgs; [dconf gcr];
      enable = true;
    };
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    # on-disk browser sync
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
  
  programs = {
    zsh.promptInit = ''eval "$(${pkgs.starship}/bin/starship init zsh)"'';
  };

  environment.variables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };

  environment.systemPackages = with pkgs; [
    git
    uutils-coreutils-noprefix
    btrfs-progs
    cifs-utils
    emptty
    starship # having starship here means pkgs.startship will be stored during build and not during promptInit
  ];

  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = true;
  };
  hardware.ledger.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  console = let
    variant = "u24n";
  in {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-${variant}.psf.gz";
    earlySetup = true;
  };

  programs.nix-ld.enable = true;
  systemd = let
    extraConfig = ''
      DefaultTimeoutStopSec=15s
    '';
  in {
    inherit extraConfig;
    user = {inherit extraConfig;};

    /*
    autologin = {
      enable = true;
      description = "Autologin";
      after = [ "systemd-user-sessions.servie" "plymouth-quit-wait.service" "getty@tty1.service" ];
      conflicts = [ "getty@tty1.service" ];
      aliases = [ "display-manager.service" ]
      
      serviceConfig = {
        Type = "simple";
        ExecStart = "autologin nyoo 'sway --unsupported-gpu'";
        IgnoreSIGPIPE = "no";
        SendSIGHUP = "yes";
        TimeoutStopSec = "30s";
        KeyringMode = "shared";
        Restart = "always";
        RestartSec = 1;
        StartLimitBurst = 5;
        StartLimitInterval = 30;
      };
    };
    */
    # Systemd OOMd
    # Fedora enables these options by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
    oomd.enableRootSlice = true;
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jre;
    };
  };
}
