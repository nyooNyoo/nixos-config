{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) map singleton optionals;

  cfg = config.modules.user.programs.neovim;
in {
  config = mkIf cfg.enable {
    environment = {
      variables.EDITOR = "nvim";

      pathsToLink = [ "/share/nvim" ];
      systemPackages = singleton (pkgs.neovim.override {
        inherit (cfg) viAlias vimAlias;

        wrapRc = false;
        wrapperArgs = optionals cfg.initRc [ "--add-flags" "-u ${cfg.initRc}" ];
        plugins = let
          formatPlugins = opt: map (x: {plugin = x; config = ""; optional = opt;});
        in (formatPlugins true cfg.startPlugins) ++ (formatPlugins false cfg.optPlugins);
      });
    };
  };
}