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
    packages = lib.mkMerge [
      {
        plymouth-copland-theme = pkgs.callPackage ./plymouth-copland-theme.nix {};
      }
    ];

    # Absorb packages into nixpkgs to be used in system configurations.
    # Not best practice, just use self
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
