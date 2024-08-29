{ inputs }: let
  lib = inputs.nixpkgs.lib;
in rec {
  filesIn = dir: (map 
    (filename: dir + "/${filename}")
    (builtins.attrNames (builtins.readDir dir)));

  dirsIn = dir: (map
    (subdir: dir + "/${subdir}")
    (builtins.attrNames (
      lib.filterAttrs 
        (name: value: value == "directory")
        (builtins.readDir dir))));

  fileNameOf = path: (builtins.head (builtins.split "\\." (builtins.baseNameOf path)));


  mkEnableFileImport = path: cfg: 
  let
    file = (fileNameOf path);
    eval = import path;

  in {
  };

  mkEnableFilesImport = paths: cfg:
    map 
      (path: (mkEnableFileImport path cfg)) 
      paths;
}
