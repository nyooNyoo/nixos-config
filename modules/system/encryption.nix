{
  config,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrs concatMapAttrs;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str nullOr attrsOf submodule;
  inherit (lib.meta) getExe;

  mapKeys = concatMapAttrs (_: attr:
    if (attr.keyFile or null != null)
    then { ${attr.keyFile} = attr.keyFile }
    else {};

  cfg = config.modules.system.encryption;
in {
  options.modules.system.encryption = {
    enable = mkEnableOption "LUKS encryption";

    rdKeyFiles = mkEnableOption "Storing of keyfiles into rd";

    devices = mkOption {
      default = {};
      type = attrsOf (submodule (
        {name, ...}: { 
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

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "luks.options=timeout=0"
	"rd.luks.options=timeout=0"

	"rootflags=x-systemd.device-timeout=0"
      ];

      initrd = {
        availableKernelModules = [
          "aesni_intel"
	  "cryptd"
	  "usb_storage"
        ];

	systemd.extraBin.cryptsetup = getExe ${pkgs.cryptsetup};

	secrets = mkIf cfg.rdKeyFiles (mapKeys cfg.devices); 

	luks.devices = mapAttrs (_: attr: attr // {
	  # Improve SSD performance
	  bypassWorkqueues = true;
	  preLVM = true;
        }) cfg.devices;
      };
    };

    warnings = if cfg.devices == { }
      then [''
          LUKS encryption is enabled without any devices set, decryption may not work.
      '']
      else [];
  };
}
