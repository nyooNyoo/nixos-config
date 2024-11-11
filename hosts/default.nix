{
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib.builders) mkNixosSystem;
    inherit (lib.lists) concatLists flatten;

    hw = inputs.nixos-hardware.nixosModules;

    # NixOS modules here
    modulePath = ../modules;

    # Defines sane defaults
    defaults = modulePath + /core;

    # Option definitions and wrappers
    system = modulePath + /system;
    common = defaults + /common;

    # Specification defaults for specific archetypes
    laptop = defaults + /forms/laptop;

    mkModules = {
      forms ? [],
      extraModules ? [],
    }: flatten ( 
      concatLists [
       [ common options ]
        forms
        extraModules
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

