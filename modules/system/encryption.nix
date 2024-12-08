{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrs concatMapAttrs;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str nullOr attrsOf submodule path;
  inherit (lib.lists) optional;
  inherit (lib.meta) getExe;
  inherit (builtins) baseNameOf;


  cfg = config.modules.system.encryption;
in {
  options.modules.system.encryption = {
    enable = mkEnableOption "LUKS encryption.";

    rdKeyFiles = mkEnableOption "Storing of keyfiles into rd.";

    #TODO; eventually make an entire authentication factorization queue system
    # yubikey 
    # keyFile
    # TPM
    # password
    # fingerprint
    # require x/y auth methods and assign priority/values
    fingerPrint = {
      enable = mkEnableOption "Fingerprint decode using compatable sensors.";
    };

    devices = mkOption {
      default = {};
      type = attrsOf (submodule (
        {name, ...}: { 
          options = {

            keyFile = mkOption {
              default = null;
              type = nullOr path;
              description = ''
                The name of the file that should
                be used as the decryption key for the encrpyed device.
                If not specified you will be prompted for passphrase.
              '';
            };

	    rdKey = mkEnableOption "Auto store the keyfile in initrd.";
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

	systemd.extraBin.cryptsetup = getExe pkgs.cryptsetup;

	luks.devices = mapAttrs (name: attr: {
	  inherit name;

	  keyFile = if attr.rdKey
	    then "/secrets/" + baseNameOf attr.keyFile
	    else attr.keyFile;

	  # Improve SSD performance
	  bypassWorkqueues = true;
	  preLVM = true;
        }) cfg.devices;

	secrets = let
          mapKeys = concatMapAttrs (_: attr: 
	    mkIf (attr.keyFile or null != null && attr.rdKey or false) {
              ${"/secrets/" + baseNameOf attr.keyFile} = attr.keyFile;
	    }
	  );

	in mapKeys cfg.devices; 
      };
    };

    warnings = optional (cfg.devices == {}) ''
          LUKS encryption is enabled without any devices set, decryption may not work.
      '';
  };
}
