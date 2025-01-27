{
  modules.programs = {
    nvim = {
      enable = true;
    };

    zsh = {
      enable = true;
      starship.enable = true;
    };

    firefox = {
      enable = true;
      extensions = {
        "ublock-origin" = {};
	"skip-redirect" = {};
	"simple-translate" = {};
	"frankerfacez" = {};
	"disable-twitch-extensions" = {};
	"bento" = {};
      }; 

      languagePacks = ["en-US"];
    };
  };
}
