{
  config,
  pkgs,
  lib,
  ...
}: let 
  inherit (lib.modules) mkDefault;

in {
  imports = [
    ./auto-cpufreq.nix
    ./acpid.nix
    ./undervolt.nix
    ./upower.nix
  ];
  
  environment.systemPackages = [
    pkgs.acpi
    pkgs.powertop
  ];

  boot = {
    kernelModules = [ "acpi_call" ];
    kernelParams = [ "intel_pstate=disabled" ]; # reccomended for auto-cpufreq
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      cpupower
    ];
  };
}
