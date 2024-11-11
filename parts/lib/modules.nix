{lib, ...}: let
  inherit (lib.modules) mkForce mkDefault mkOptionDefault;
  inherit (lib.attrsets) mapAttrRecursive;

  mkForceAttr = mapAttrRecursive (_: v: mkForce v);
  mkDefaultAttr = mapAttrRecursive (_: v: mkDefault v);
  mkOptionDefaultAttr = mapAttrRecursive (_: v: mkOptionDefault v);

in {
  inherit mkForceAttr;
  inherit mkDefaultAttr;
  inherit mkOptionDefaultAttr;
}
