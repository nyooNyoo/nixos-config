{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  i18n = let
    defaultLocale = "en_US.UTF-8";
  in {
    inherit defaultLocale;

    extraLocaleSettings = {
      LANG = defaultLocale;
      
      LC_CTYPE = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_TIME = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_MESSAGES = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_NAME = defaultLocale;
      LC_ADDRESS = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
    };
  };

  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = true;
  };
}
