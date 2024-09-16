{
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  hardware,enableRedistributableFirmware = lib.mkDefault true;
}
