{
  config,
  lib,
  ...
}: let
  forHost = hostnames: secretFile: secretName: extra:
    lib.mkIf (builtins.elem config.networking.hostName hostnames) {
      ${secretName} =
        {
          file = secretFile;
        }
        // extra;
    };

  user = {
    owner = "nyoo";
    group = "users";
  };
in {
}
