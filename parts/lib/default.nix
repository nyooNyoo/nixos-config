{ 
  inputs,
  withSystem,
   ...
}: let
  inherit (inputs.nixpkgs) lib;

  lib' = lib.extend (final: prev: let
    callLibs = module:
      import module {
        inherit withSystem;
        inherit inputs;
        lib = final;
      };
  in lib.recursiveUpdate prev {
    files = callLibs ./files.nix;
    builders = callLibs ./builders.nix;
    lists = callLibs ./lists.nix;
  });

in {
  perSystem._module.args.lib = lib';
  flake.lib = lib';
}    
  
    # Merge all libraries from imports here
    #extensions = lib.composeManyExtensions [
    #  (_: _: inputs.nixpkgs.lib)
    #  (_: _: inputs.flake-parts.lib)
    #];

    #extendedLib = (lib.makeExtensible myLib).extend extensions;

