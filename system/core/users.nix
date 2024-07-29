{pkgs, ...}: {
  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };
  
  users = {
    mutableUsers = false;
    users = {
      root.hashedPasswordFile = "/persist/sercrets/root";
      nyoo = {
        isNormalUser = true;
        shell = pkgs.zsh;
        hashedPasswordFile = "/persist/secrets/nyoo";
        extraGroups = [
          "wheel"
          "docker"
          "audio"
          "video"
          "networkmanager"
          "nix"
        ];
        uid = 1000;
      };
    };
  };
}
