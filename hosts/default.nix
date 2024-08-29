{
  nixpkgs,
  self,
  ...
} @ inputs: let
  myLib = import ../myLib {inherit inputs;};
  inherit (self) inputs;

  core = ../system/core;
  bootloader = ../system/core/bootloader.nix;
  #impermanence = ../system/core/impermanence.nix;
  wayland = ../system/wayland;
  hw = inputs.nixos-hardware.nixosModules;
  firefox = ../modules/firefox;
  social = ../modules/social;

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
        core
        firefox
	social
      ];
    specialArgs = {inherit inputs myLib;};
  };
}

