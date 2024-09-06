{ lib, ... }: let
  inherit (builtins) map removeAttrs;
  inherit (lib) mkIf mkEnableOption;

  # rather cursed function, creates an attrset that imports the file specified
  # if the option it creates is enabled somewhere.
  mkEnableModuleImport = path: opt: cfg: let
    file = (fileNameOf path);
    func = import path {inherit perSystem._module.args;};
    extra [ ({...}: {
      options = {opt.${file}.enable = (mkEnableOption "${file}");};})
    ];
  in {
    imports = (func.imports or []) ++ extra;
    config = (mkIf cfg.${file}.enable (func.config));
  };

  # useful with lib.dirsIn or lib.filesIn
  mkEnableModuleImports = path: cfg:
    map
      (path: (mkEnableModuleImport path opt cfg))
      paths;
in {
  inherit mkEnableModuleImport mkEnableModuleImports;
}
