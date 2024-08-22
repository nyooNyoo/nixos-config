{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;

  core = ../system/core;
  bootloader = ../system/core/bootloader.nix;
  #impermanence = ../system/core/impermanence.nix;
  wayland = ../system/wayland;
  hw = inputs.nixos-hardware.nixosModules;
  firefox = ../modules/firefox.nix;

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
      ];
    specialArgs = {inherit inputs;};
  };
}

