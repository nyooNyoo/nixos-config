{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib.builders) mkNixosSystem;

    hw = inputs.nixos-hardware.nixosModules;
    
    modulePath = ../modules;

    coreModules = modulePath + /core;

    extras = modulePath + /extra;
    options = modulePath + /options;
    common = coreModules + /common;
    
    #forms#
    laptop = coreModules + /forms/laptop;

    mkModules = {
      moduleTrees ? [ common extras options ],
      forms ? [],
      extraModules ? [],
    } @ args:
      flatten ( 
        concatLists [
          concatLists [ modulesTrees forms ]
          args.extraModules
        ]
      );
  in {
    vessel = mkNixosSystem {
      inherit withSystem;
      hostname = "nyoo";
      system = "x86_64-linux";
      modules = mkModules {
        forms = [ laptop ];
        extraModules = [ hw.dell-xps-15-9520-nvidia ];
      };
    };
  };
}

