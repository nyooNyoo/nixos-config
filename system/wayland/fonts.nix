{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      material-icons
      material-design-icons
      roboto
      work-sans
      comic-neue
      source-sans
      twemoji-color-font
      comfortaa
      inter
      lato
      jost
      dejavu_fonts
      iosevka-bin
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
    ];

    enableDefaultPackages = false;

    # this fixes emoji stuff
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrains Mono" "JetBrainsMono Nerd Font" "Twitter Color Emoji" "Material Icons Sharp" ];
        sansSerif = ["Jost*" "Twitter Color Emoji"];
        serif = ["Noto Serif" "Twitter Color Emoji" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };
}
