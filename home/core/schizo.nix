{inputs, config, ...}: {
config.programs.schizofox = {
  enable = true;

  theme = {
    font = "JetBrainsMono Nerd Font Propo";
  };

  search = {
    defaultSearchEngine = "Brave";
    removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
    searxUrl = "https://searx.be";
    searxQuery = "https://searx.be/search?q={searchTerms}&categories=general";
  };

  security = {
    sanitizeOnShutdown = false;
    sandbox = true;
    userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
  };

  misc = {
    drm.enable = true;
    disableWebgl = false;
    contextMenu.enable = true;
  };

  extensions = {
    simplefox.enable = true;
    darkreader.enable = true;

    extraExtensions = {
      "firefox@betterttv.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/betterttv/latest.xpi";
    };
  };

};
}
