{
  stdenvNoCC,
  backgroundDark ? "19171a",
  background ? "201e21",
  font ? "Lato",
  border ? "00000000",
  extraUserChrome ? "",
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "simplefox-userChrome";
  version = "0.0.1";

  src = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/migueravila/SimpleFox/master/chrome/userChrome.css";
    sha256 = "0jqv1fc1h1a2whgxa8rrq58znfaplrwhpkh5vrcja6hwbix1j1dh";
  };

  unpackPhase = ''
    cp -v $src userChrome.css
    chmod +w userChrome.css
  '';

  dontBuild = true;
  dontConfigure = true;

  patches = [
    ./patches/0001-add-font-config.patch
    ./patches/0002-navbar-tweaks.patch
  ];

  postPatch = ''
    echo "${extraUserChrome}" >> userChrome.css
    sed -i "s/19171a/${backgroundDark}/g" userChrome.css
    sed -i "s/201e21/${background}/g" userChrome.css
    sed -i "s/rgba(0, 0, 0, 0)/#${border}/g" userChrome.css
    sed -i "s/Lato/${font}/g" userChrome.css
    echo '\n* { font-family: "${font}" !important; }' >> userChrome.css
  '';

  installPhase = ''
    runHook preInstall
    cp -v userChrome.css $out
    runHook postInstall
  '';
}
