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
  hmModule = inputs.home-manager.nixosModules.home-manager;

  shared = [core agenix];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.nyoo = {
      imports = [../home];

     # _module.args.theme = import ../theme;
    };
  };

in {
  vessel = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = 
      [
        {networking.hostName = "vessel";}
        ./vessel
        wayland
        hmModule
        bootloader
        #impermanence
        hw.dell-xps-15-9520-nvidia
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
}

