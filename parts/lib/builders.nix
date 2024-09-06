{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self nixpkgs;
  inherit (lib) nixosSystem;
  inherit (lib.lists) singleton concatLists;
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) recursiveUpdate;

  mkNixosSystem = {
    withSystem,
    system,
    hostname,
    ...
  } @ args:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      nixosSystem {
        specialArgs = recursiveUpdate {
          inherit lib;
          inherit inputs self inputs' self';
        } (args.specialArgs or {});

      modules = concatLists [
        (singleton {
          networking.hostName = args.hostname;
          nixpkgs = {
            hostPlatform = mkDefault args.system;
            flake.source = nixpkgs.outPath;
          };
        })
        (args.modules or [])
      ];
    });
in {
  inherit mkNixosSystem;
}
