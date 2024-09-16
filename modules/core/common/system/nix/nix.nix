{
  config,
  pkgs,
  cfg,
  lib,
  inputs,
  inputs',
  ...
}: {
  environment = {
    # set channels (backwards compatibility)
    sessionVariables.FLAKE = "/home/nyoo/nixos-config";
    etc = {
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
    };

    systemPackages = with pkgs; [
      git
      deadnix
      alejandra
      statix
      nix-output-monitor
    ];
    defaultPackages = [];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;

      overlays = [
        (self: super: {
          networkd-dispatcher = super.networkd-dispatcher.overrideAttrs (oldAttrs: {
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.wrapGAppsNoGuiHook];
          });
        })
      ];
    };
  };

  # faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  nix = {
    gc.automatic = lib.mkDefault false;
    package = pkgs.nixVersions.git;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      experimental-features = nix-command flakes recursive-nix
      keep-outputs = true
      warn-dirty = false
      keep-derivations = true
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings = {
      flake-registry = "/etc/nix/registry.json";
      auto-optimise-store = true;
      builders-use-substitutes = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      sandbox = true;
      max-jobs = "auto";
      log-lines = 20;
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];

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
  system.stateVersion = "24.05"; 
}
