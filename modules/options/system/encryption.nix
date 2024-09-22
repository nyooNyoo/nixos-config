{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

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
      type = with types; attrsOf (submodule (
        { config, name, ...}: { 
          options = {

            name = mkOption {
              visible = false;
              default = name;
              type = types.str;
              description = "Name of the unencrypted device";
            };

            keyFile = mkOption {
              default = null;
              type = types.nullOr types.str;
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
