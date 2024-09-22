{ 
  inputs,
  withSystem,
   ...
}: let
  inherit (inputs.nixpkgs) lib;
  
  # This lib is made in the same fashion as nixpkgs.lib
  # shoutouts to NotAShelf for their demonstration on
  # how to override lib without conflicts
  myLib = self: let
    callLibs = file: import file { 
      inherit inputs;
      lib = self; 
    };
    in {
      builders = callLibs ./builders.nix {inherit withSystem};
      files = callLibs ./files.nix;
    
      # in case I want to be lazy later
      #inherit (self.files) ....
    };
  
    # Merge all libraries from imports here
    extensions = lib.composeManyExtensions [
      (_: _: inputs.nixpkgs.lib)
      (_: _: inputs.flake-parts.lib)
    ];

    extendedLib = (lib.makeExtensible myLib).extend extensions;
  in {
     # Overwrites the 'lib' argument from flake-parts so that it's easily
     # accesible inside 'inputs'.
     perSystem._module.args.lib = extendedLib;

    # exposes the library to self.lib.
    flake.lib = extendedLib;     
}
