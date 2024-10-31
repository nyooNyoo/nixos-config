{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str nullOr attrsOf submodule;

  cfg = config.modules.system.encryption;
in {
  config = mkIf cfg.enable {
    warnings =
      if config.modules.system.encryption.devices == { }
      then [
        ''
          LUKS encryption is enabled without any devices set, decryption may not work.
        ''
      ]
      else [];
  };

  options.modules.system.encryption = {
    enable = mkEnableOption "LUKS encryption";

    devices = mkOption {
      default = { };
      type = attrsOf (submodule (
        {config, name, ...}: { 
          options = {

            name = mkOption {
              visible = false;
              default = name;
              type = str;
              description = "Name of the unencrypted device";
            };

            keyFile = mkOption {
              default = null;
              type = nullOr str;
              description = ''
                The name of the file that should
                be used as the decryption key for the encrpyed device.
                If not specified you will be prompted for passphrase.
              '';
            };
          };
        }
      ));
    };
  };
}
