{inputs, ...}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;

    inherit (lib.builders) mkNixosSystem;
    inherit (lib.lists) concatLists flatten;

    hw = inputs.nixos-hardware.nixosModules;

    # TODO change module importing

    # NixOS modules here
    modulePath = ../modules;

    # Option definitions and wrappers
    system = modulePath + /system;
    programs = modulePath + /programs;

    # Defines sane defaults
    defaults = modulePath + /core;
    common = defaults + /common;

    # Specification defaults for specific archetypes
    laptop = defaults + /forms/laptop;

    mkModules = {
      forms ? [],
      extraModules ? [],
    }: flatten ( 
      concatLists [
       [ common system programs ]
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

