{
  pkgs,
  ...
}: {
  imports = [
  ./nyoo.nix
  ./root.nix
  ];

  config = {
    users = {
      defaultUserShell = pkgs.zsh;

      allowNoPasswordLogin = false;
      enforceIdUniqueness = true;

      #mutableUsers = false;
    };
  };
}
