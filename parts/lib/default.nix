{ inputs, ...}: let
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
      extendedLib = {
        # Helpers for file and directory fetching 
        files = callLibs ./files.nix;


        # Module building, vital to the flake's organization
        #modules = callLibs ./modules.nix;
      };
      builders = callLibs ./builders.nix;
    
      # in case I want to be lazy later
      #inherit (self.extendedLib.files) ....
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
