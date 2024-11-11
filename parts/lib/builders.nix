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

  # TODO clean this.
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
          inherit lib inputs self inputs' self' hostname;
        } (args.specialArgs or {});

      modules = concatLists [
        (singleton {
          networking.hostName = args.hostname;
          nixpkgs = {
            hostPlatform = mkDefault args.system;
            flake.source = nixpkgs.outPath;
          };
        })
        (singleton "${inputs.self.outPath}/hosts/${args.hostname}")
        (args.modules)
      ];
    });

in {
  inherit mkNixosSystem;
}
