{
  inputs,
  withSystem,
  lib,
  ...
}: let
  inherit (inputs) self nixpkgs;
  inherit (lib) nixosSystem;
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) recursiveUpdate;

  # TODO clean this.
  mkNixosSystem = {
    system,
    hostname,
    modules ? [],
    specialArgs ? {},
  }:
    withSystem system (ctx:
      nixosSystem {
	inherit lib;

        specialArgs = recursiveUpdate {
          inherit inputs hostname;
          inherit (ctx) inputs';
	  inherit (ctx.self') packages;
        } specialArgs;

        modules = [
          {
            imports = ["${inputs.self.outPath}/hosts/${hostname}"];
            networking.hostName = hostname;
	    nixpkgs.hostPlatform = system;
          }
        ] ++ modules;
      }
    );

in {
  inherit mkNixosSystem;
}
