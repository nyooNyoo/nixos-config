{ ...
}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
    extraSessionCommands = ''
      export XDG_SESSION_DESKTOP=sway
    '';
  };
}
