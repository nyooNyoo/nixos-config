{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) attrAny;
in {
  imports = [
  ./nyoo.nix
  ./root.nix
  ];

  users = {
    defaultUserShell = pkgs.zsh;

    allowNoPasswordLogin = false;
    enforceIdUniqueness = true;

    mutableUsers = false;
  };

  programs.zsh.enable = mkDefault config.users.defaultUserShell == pkgs.zsh ||
    attrAny (x: x.shell == pkgs.zsh) config.users.users;
}
