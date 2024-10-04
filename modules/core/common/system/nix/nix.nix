{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.lists) singleton;

in {
  nix = {
    # Not to get political or anything lol
    package = pkgs.lix;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # Garbage Collector
    gc = {
      automatic = true;
      # In case of disaster I'd rather deal with it on the weekend.
      dates = "Sun";
      # TODO Find a way to keep latest 10 Generations 
      options = "--delete-older-than 30d";
    };

    # Store Optimizer
    optimise = {
      automatic = true;
      # Tuesday, Thursday, Saturday
      dates = singleton "Tue,Thu,Sat"   
    };

    settings = {
      # https://nix.dev/manual/nix/2.18/command-ref/conf-file.html

      auto-optimise-store = true;

      # Restarts download after 30 seconds of no contact.
      stalled-download-timeout = 30;

      # The curl connection timeout, let us know if we have no internet.
      connect-timeout = 10;

      allowed-users = ["root" "@wheel"];
      trusted-users = ["root" "@wheel"];

      # Free 5GB when less than 1GB is left.
      min-free = ${toString (1 * 1024 * 1024 * 1024)};
      max-free = ${toString (5 * 1024 * 1024 * 1024)};

      # Isolate builds, stop if something prevents that.
      sandbox = true;
      sandbox-fallback = false;

      max-jobs = "auto";

      # Gives some extra lines to the tail of log
      log-lines = 20;

      extra-experimental-features = [
        "flakes"
        "nix-command"
        "recursive-nix"
        "ca-derivations"
        "no-url-literals"
      ];
      
      # Complete declaritive purity.
      pure-eval = true;

      # I hate this default
      warn-dirty = false;

      # Alert if a third party is changing the config. 
      accept-flake-config = false;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      ];
    };
  };
}
