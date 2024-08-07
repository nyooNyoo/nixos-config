{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;
  core = ../system/core;
  bootloader = ../system/core/bootloader.nix;
  impermanence = ../system/core/impermanence.nix;
  wayland = ../system/wayland;
  hw = inputs.nixos-hardware.nixosModules;
  agenix = inputs.agenix.nixosModules.age;

  shared = [core agenix];


in {
  vessel = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = 
      [
        {networking.hostName = "vessel";}
        ./vessel
        wayland
        bootloader
        #impermanence
        hw.dell-xps-15-9520-nvidia
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
}

