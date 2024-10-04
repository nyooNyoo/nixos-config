{ 
  inputs,
  withSystem,
   ...
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib.fixedPoints) composeManyExtensions;
  inherit (lib.attrsets) recursiveUpdate;

  # An overlay of my library to go onto nixpkgs'
  myLib = (final: prev: let
    callLibs = module:
      import module {
        inherit withSystem;
        inherit inputs;
        lib = final;
      };
  in recursiveUpdate prev {

    # Functions to mess with some 
    files = callLibs ./files.nix;

    # Builders for systems
    builders = callLibs ./builders.nix;

    # Some helper functions for lists
    lists = callLibs ./lists.nix;

    # Nixpkgs style inherits, I don't like these
    #inherit (files) filesIn dirsIn fileNameOf;
  });


  # Compose all imported libraries
  extensions = composeManyExtensions [
    myLib
    (_: _: inputs.flake-parts.lib)
  ];

  # Finally create the lib by applying the overlays onto nixpkgs
  lib' = lib.extend extensions;

in {
  perSystem._module.args.lib = lib';
  flake.lib = lib';
}    
