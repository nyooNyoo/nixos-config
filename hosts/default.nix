{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib.builders) mkNixosSystem;

    hw = inputs.nixos-hardware.nixosModules;

    core = ../modules/core;
    bootloader = ../modules/core/bootloader.nix;
    #impermanence = ../system/core/impermanence.nix;
    wayland = ../modules/wayland;
    firefox = ../modules/firefox;
    social = ../modules/social;

  in {
    vessel = mkNixosSystem {
      inherit withSystem;
      hostname = "nyoo";
      system = "x86_64-linux";
      modules = [
        ./vessel
        wayland
        bootloader
        #impermanence
        hw.dell-xps-15-9520-nvidia
        core
        firefox
	social
      ];
    };
  };
}

