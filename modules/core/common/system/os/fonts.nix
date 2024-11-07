{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;

in { 
  fonts = {
    packages = with pkgs; [
      material-icons
      corefonts
      twemoji-color-font
      noto-fonts
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];

    fontconfig = {
      defaultFonts = mkDefault rec {
        emoji = ["Twitter Color Emoji" "Material Icons Sharp"];
        monospace = ["JetBrainsMono Nerd Font Mono"] ++ emoji;
	sansSerif = ["JetBrainsMono Nerd Font Mono"] ++ emoji; 
	serif = ["Noto Serif"] ++ emoji; 
      };
    };
  };
}
