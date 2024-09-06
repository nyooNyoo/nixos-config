{ lib, ...}: let
  inherit (builtins) map attrNames readDir head split baseNameOf;
  inherit (lib) filterAttrs;

  filesIn = dir: (map
    (filename: dir + "/${filename}")
    (attrNames (readDir dir)));

  dirsIn = dir: (map
    (subdir: dir + "/${subdir}")
    (attrNames (
      filterAttrs
        (_: val: val == "directory")
        (readDir dir))));

  fileNameOf = path: (head (split "\\." (baseNameOf path)));
in {
  inherit filesIn dirsIn fileNameOf;
}
