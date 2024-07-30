{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  hardware = {
    graphics.enable = true;
    
    nvidia = {
      modesetting.enable = true;

      # turn off gpu when not in use
      powerManagement.enable = true;
      powerManagement.finegrained = true;

      # `nvidia-settings`
      nvidiaSettings = true;
    };
  };
  
  # Use the systemd-boot EFI boot loader.
  networking.hostName = "vessel"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.scanRandMacAddress = false;

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "America/New_York";

  console = {
    keyMap = "us";
  };

  services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    fastfetch
    firefox
    grim
    slurp
    wl-clipboard
    mako
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}

