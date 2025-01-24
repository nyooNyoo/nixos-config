{stdenvNoCC, ...}: let
  version = "0.0.1";
  pname = "simplefox-userContent";
in
  stdenvNoCC.mkDerivation {
    inherit version pname;

    src = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/migueravila/SimpleFox/master/chrome/userContent.css";
      sha256 = "1ghxyhsfvib43lrrgya9bda5kq0mpx1zk6jld27l33rbiimyrw8j";
    };

    dontUnpack = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      cp -vr $src $out
      runHook postInstall
    '';
  }
