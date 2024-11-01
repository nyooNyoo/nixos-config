{
  lib,
  ...
}: let
  inherit (lib.attrsets) attrNames mapAttrsToList getAttr;
  inherit (lib.lists) head elem;

  attrHead = x: getAttr (head (attrNames x)) x;
  # Inefficient but fine for now
  attrAny = pred: x: elem true (mapAttrsToList (_: pred) x);
in {
  inherit attrHead;
  inherit attrAny;
}
