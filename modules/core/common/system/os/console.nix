{pkgs, lib, ...}: let
  inherit (lib.modules) mkDefault;

in {
  console = let
    format = "8x16b";
  in {
    enable = true;
    earlySetup = true;

    keyMap = mkDefault "us";

    font = "TamzenForPowerline${format}";
    packages = with pkgs; [ tamzen ];
  };
}
