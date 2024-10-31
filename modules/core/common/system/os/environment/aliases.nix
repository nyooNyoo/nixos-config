{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  environment.shellAliases = {
    nr = "nix-store --verify; pushd /home/nyoo/nixos-config; ${getExe pkgs.nh} os switch .; popd"; 
  };
}
