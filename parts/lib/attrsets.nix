{
  lib,
  ...
}: let
  inherit (lib.attrsets) attrNames getAttr;
  inherit (lib.lists) head;

  attrHead = x: getAttr (head (attrNames x)) x;
  hasEnabledAttr = s: x: x.s.enabled or false;
in {
  inherit attrHead;
  inherit hasEnabledAttr;
}
