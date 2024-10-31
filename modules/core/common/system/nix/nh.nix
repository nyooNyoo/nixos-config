{ 
  config, 
  ...
}: let

  cfg = config.modules.system.nix;
in {
  programs.nh = {
    enable = true;
    clean = {
      inherit (cfg.gc) enable;
      extraArgs = "--keep-since 5d --keep ${cfg.gc.keep}";
      inherit (cfg.gc) dates;
    };
  };
}
