{pkgs, ...}: {
  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };
  
  users = {
    users = {
      nyoo = {
        isNormalUser = true;
        shell = pkgs.zsh;
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
