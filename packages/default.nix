{
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    packages = {
      # Plymouth bootscreen themes
      plymouth-copland-theme = pkgs.callPackage ./plymouth-themes/plymouth-copland-theme.nix {};
      plymouth-hellonavi-theme = pkgs.callPackage ./plymouth-themes/plymouth-hellonavi-theme.nix {};

      # Simplefox, firefox customization
      simplefox-userChrome = pkgs.callPackage ./simplefox/userChrome.nix {};
      simplefox-userContent = pkgs.callPackage ./simplefox/userContent.nix {};
    };
  };
}
