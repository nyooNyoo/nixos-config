{
  config,
  lib,
  pkgs,
  ...
}: let 
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) attrAny;
in {
  programs.zsh = {
    # Enable when required.
    enable = mkDefault (config.users.defaultUserShell == pkgs.zsh ||
      attrAny (x: x.shell == pkgs.zsh) config.users.users);

    promptInit = ''eval "$(${pkgs.starship}/bin/starship init zsh)"'';
    enableCompletion = true;
  };
}
