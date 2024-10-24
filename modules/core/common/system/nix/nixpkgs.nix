{
  nixpkgs.config = {
    # It's better to be alerted when an installed package
    # or a package attempting to be installed has been deliberartely
    # marked as broken. Manual steps should then be taken to fix the breakage.
    allowBroken = false;

    # Not much of an argument to keep this false
    allowUnfree = true;

    # Speed up of most package builds
    enableParallelBuildingByDefault = false;
  };
}
