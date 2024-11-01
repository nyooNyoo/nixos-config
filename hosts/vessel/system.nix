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
    # on-disk browser sync
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
  };
  
  programs = {
    zsh.promptInit = ''eval "$(${pkgs.starship}/bin/starship init zsh)"'';
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    uutils-coreutils-noprefix
    btrfs-progs
    cifs-utils
    starship # having starship here means pkgs.startship will be stored during build and not during promptInit
  ];

  console = {
    earlySetup = true;
    keyMap = "us";
  };

  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  systemd = let
    extraConfig = ''
      DefaultTimeoutStopSec=15s
    '';
  in {
    inherit extraConfig;
    user = {inherit extraConfig;};
    oomd.enableRootSlice = true;
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jre;
    };
  };
}
