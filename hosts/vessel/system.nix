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

  environment.systemPackages = with pkgs; [
    vim
    git
    btrfs-progs
    cifs-utils
    starship # having starship here means pkgs.startship will be stored during build and not during promptInit
  ];

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
}
