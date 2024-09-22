{
  inputs,
  withSystem,
  lib,
  ...
}: let
  inherit (inputs) self nixpkgs;
  inherit (lib) nixosSystem;
  inherit (lib.lists) singleton concatLists;
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) recursiveUpdate;
  
  modulePath = ../../modules;

  mkNixosSystem = {
    system,
    hostname,
    modules ? [],
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
        (singleton ./${args.hostname})
        (args.modules)
      ];
    });

in {
  inherit mkNixosSystem;
}
