{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  tpm = config.modules.system.hardware.tpm;
in {
  config = mkIf tpm.enable {
    boot.kernelModules = [ "uhid" ];

    security.tpm2 = {
      enable = true;

      # Makes /dev/tpm[0-9] accessible to security.tpm2.tssUser.
      # We don't use tssGroup.
      applyUdevRules = true;

      # The resource manager daemon, it runs under
      # the tssUser which will now be 'tss'
      abrmd.enable = true;


      # Exports TCTI (TPM Command Transmission Interface) variables.
      # - 'TPM2TOOLS_TCTI'
      # - 'TPM2_PKCS11_TCTI;
      tctiEnvironment.enable = true;


      # Cryptographic library + tooling
      pkcs11.enable = true;
    };

    environment.systemPackages = [
      pkgs.tpm2-tools
      pkgs.tmp2-tss
      pkgs.tmp2-abrd
    ];
  };
}
