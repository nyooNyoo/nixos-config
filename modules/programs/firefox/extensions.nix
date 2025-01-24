{
  config,
  lib,
  ...
}: let 
  inherit (lib.attrsets) nameValuePair optionalAttrs listToAttrs attrNames;
  inherit (lib.lists) map;

  extensionLongIDs = {
    ## BROWSER EXTENSIONS
    ublock-origin = "uBlock0@raymondhill.net";
    privacy-badger17 = "jid1-MnnxcxisBPnSXQ@jetpack";
    clearurls = "{74145f27-f039-47ce-a470-a662b129930a}";
    sponsorblock = "sponsorBlocker@ajay.app";
    simple-translate = "simple-translate@sienori";
    languagetool = "languagetool-webextension@languagetool.org";
    betterttv = "firefox@betterttv.net";
    frankerfacez = "frankerfacez@frankerfacez.com";
    disabled-twitch-extensions = "{disable-twitch-extensions@rootonline.de}";
    bento = "{cb7f7992-81db-492b-9354-99844440ff9b}";

    ## THEMES
    eumyangu = "{894994d3-315f-40bb-b1a6-6283cf253e0a}";
  };

  mkExtension = shortID:
    let longID = extensionLongIDs.${shortID};
    in nameValuePair longID {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortID}/latest.xpi";
      installation_mode = "normal_installed";
      updates_disabled = "true";
      default_area = "menupanel";
    };

  mkLanguagePack = lang:
    nameValuePair "langpack-${lang}@firefox.mozilla.org" {
      install_url = "https://releases.mozilla.org/pub/firefox/releases/${config.modules.programs.firefox.package.version}/linux-x86_64/xpi/${lang}.xpi";
      installation_mode = "normal_installed";
    };

in {
  list = attrNames extensionLongIDs;

  mkExtensions = extensions: langs: lock: listToAttrs (
    map mkExtension extensions ++
    map mkLanguagePack langs) //
  optionalAttrs lock {"*".installation_mode = "blocked";};
}
