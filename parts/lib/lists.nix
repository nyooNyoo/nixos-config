{
  lib,
  ...
}: let
  inherit (lib.lists) mutuallyExclusive;

  mutuallyInclusive = x: y: !mutuallyExclusive x y;
in {
  inherit mutuallyInclusive;
}
