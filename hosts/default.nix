{
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib.builders) mkNixosSystem;
    inherit (lib.lists) concatLists flatten;

    hw = inputs.nixos-hardware.nixosModules;

    modulePath = ../modules;
    coreModules = modulePath + /core;

    extras = modulePath + /extra;
    options = modulePath + /options;
    common = coreModules + /common;

    laptop = coreModules + /forms/laptop;

    mkModules = {
      forms ? [],
      extraModules ? [],
    } @ args:
      flatten ( 
        concatLists [
          [ common options ]
          args.forms
          args.extraModules
        ]
      );

  in {
    vessel = mkNixosSystem {
      hostname = "vessel";
      system = "x86_64-linux";
      modules = mkModules {
        forms = [ laptop ];
        extraModules = [ hw.dell-xps-15-9520-nvidia ];
      };
    };
  };
}

