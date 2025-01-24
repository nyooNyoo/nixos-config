{pkgs, ...}: {
  AppAutoUpdate = false;

  ## Security / Privacy
  OverrideFirstRunPage = "";
  DisableTelemetry = true;
  #CaptivePortal = true;
  DisableFirefoxStudies = true;
  DisableFirefoxAccounts = true;
  DisablePocket = true;
  DisableSetDesktopBackground = true;
  PromptForDownloadLocation = true;

  # Tracking Protection
  EnableTrackingProtection = {
    Cryptomining = true;
    Fingerprinting = true;
    Locked = true;
    Value = true;
  };

  # Firefox Home
  FirefoxHome = {
    Search = true;
    Pocket = false;
    Snippets = false;
    TopSites = false;
    Highlights = false;
  };

  # How Schizofox should handle cookies
  Cookies = {
    Behavior = "accept";
    ExpireAtSessionEnd = false;
    Locked = false;
  };

  # Attempt to support Smartcards (e.g. Nitrokeys) by using a proxy module.
  # This should provide an easier interface than `nixpkgs.config.firefox.smartcardSupport = true`
  SecurityDevices = {
    "PKCS#11 Proxy Module" = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
  };

  ## Shutdown sanitization behaviour
  DisableFormHistory = true;
  SanitizeOnShutdown = true;

  ## Irrelevant
  DontCheckDefaultBrowser = true;

  ## Misc
  NoDefaultBookmarks = true;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;
  DisplayBookmarksToolbar = false;
  TranslateEnabled = true;
  ShowHomeButton = false;

  # User Messaging
  UserMessaging = {
    ExtensionRecommendations = false;
    SkipOnboarding = true;
    MoreFromMozilla = false;
  };

  #Bookmarks = ;
}
