{ inputs, lib, config }: 
rec {
  filesIn = dir: (map 
    (filename: dir + "/${filename}")
    (builtins.attrNames (builtins.readDir dir)));

  dirsIn = dir:
    inputs.nixpkgs.lib.filterAttrs 
      (name: value: value == "directory")
      (builtins.readDir dir);

  fileNameOf = path: (builtins.head (builtins.split "\\." (builtins.baseNameOf path)));


  mkEnableFileImport = path: cfg: 
  let
    file = fileNameOf path;
    eval = import path;
    evalNoImports = builtins.removeAttrs eval [ "imports" "options" ];

  in {
    imports = (eval.imports or []);
    options = {${cfg}.${file}.enable = lib.mkEnableOption "${file}";};  
    config = lib.mkIf config.${cfg}.${file}.enable (eval.config or evalNoImports);
  };

  mkEnableFilesImport = paths: cfg:
    map 
      (path: (mkEnableFileImport path cfg)) 
      paths;
}
