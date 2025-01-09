{ 
  config, 
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) concatMapAttrs filterAttrs attrNames;
  inherit (lib.lists) elem;
  inherit (lib.types) listOf enum;

  extensions = import ./extensions.nix;
  cfg = config.modules.programs.firefox;
in {
  options.modules.programs.firefox = {
    enable = mkEnableOption "Firefox web browser.";

    extensions = mkOption {
      type = listOf (enum (attrNames extensions));
      default = ["ublock-origin" "privacy-badger17" "clearurls"];
      description = ''
        List of firefox extensions available in the mozilla store by their short id (found in the download url).
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      languagePacks = ["en-US"];

      policies = {
        DisableTelemetry = true;
	DisableFirefoxStudies = true;
	DisablePocket = true;
	DisableFirefoxAccounts = true;
	DisableAccounts = true;
	DisableFirefoxScreenshots = true;

	OverrideFirstRunPage = "";
	OverridePostUpdatePage = "";

	DontCheckDefaultBrowser = true;
	DisplayBookmarksToolbar = "never";
	DisplayMenuBar = "default-off";
	SearchBar = "unified";
	
	EnableTrackingProtection = {
	  Value = true;
	  Locked = true;
	  Cryptomining = true;
	  Fingerprinting = true;
	};

	ExtensionSettings = 
	  concatMapAttrs (shortID: longID: {
	    ${longID} = {
	      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortID}.xpi";
	      installation_mode = "forced_installed";
	    };
	  }) (filterAttrs (shortID: _: elem shortID cfg.extensions) extensions);
	

	Preferences = let
	  lock-false = {
	    Value = false;
	    Status = "locked";
	  };

	  lock-true = {
	    Value = true;
	    Status = "locked";
	  };
	in { 
          "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
	  "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;
        };
      };
    };
  };
}
