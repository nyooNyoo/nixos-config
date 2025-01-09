{inputs, ...}:
{perSystem = {
    system,
    inputs',
    lib,
    ...
  }: let
    inherit (inputs') nixpkgs;
    pkgs = inputs'.nixpkgs.legacyPackages;

  in rec {
    # Define packages to be used by other flakes possibly.
    # Would maping the values in here be better than explicit?
    packages = lib.mkMerge [
      {
        plymouth-copland-theme = pkgs.callPackage ./plymouth-copland-theme.nix {};
	plymouth-hellonavi-theme = pkgs.callPackage ./plymouth-hellonavi-theme.nix {};
      }
    ];

    # Absorb packages into nixpkgs to be used in system configurations.
    # Not best practice, just use self.packages
    /*
    _module.args.pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
	allowBroken = false;
	enableParallelBuildingByDefault = false;
      };
      overlays = [ (final: packages)];
    };
    */
  };
}
