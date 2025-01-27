{ 
  config, 
  pkgs,
  packages,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.attrsets) mapAttrsToList foldlAttrs;
  inherit (lib.types) listOf str;

  profileDir = "/var/lib/firefox/default/profile";

  policyFormat = pkgs.formats.json {};

  cfg = config.modules.programs.firefox;
in {
  imports = [
    ./extensions.nix
  ];

  options.modules.programs.firefox = {
    enable = mkEnableOption "Firefox web browser.";
    package = mkPackageOption pkgs "firefox" {};

    languagePacks = mkOption {
      type = listOf str;
      default = ["en-US"];
      description = ''
        Language-packs to install
      '';
    };

    extraPolicies = mkOption {
      type = policyFormat.type;
      default = {};
      description = ''
        Group policies to install.
	See https://mozilla.github.io/policy-templates
	or about:policies.
      '';
    };

    theme = {
      colors = let
        mkColorOption = name: default: mkOption {
          type = str;
	  default = default;
	  example = default;
	  description = "Hexidecimal color for ${name}";
        };
      in {
        backgroundDark = mkColorOption "backgroundDark" "181825";
	background = mkColorOption "background" "1e1e2e";
	foreground = mkColorOption "foreground" "cdd6f4";
	primary = mkColorOption "primary" "aaf2ff";
	border = mkColorOption "border" "00000000";
      };

      font = mkOption {
        type = str;
	default = "JetBrainsMono Nerd Font Mono";
	example = "Lexend";
	description = "Default font for UI";
      };

      extraUserChrome = mkOption {
        type = str;
	default = "";
	description = ''
	  CSS to be appended onto simplefox's
	  userChrome.css file.
	'';
      };

      extraUserContent = mkOption {
        type = str;
	default = "";
	description = ''
	  CSS to be appended onto simplefox's
	  userContent.css file.
	'';
      };
    };
  };

  config = mkIf cfg.enable {
    programs.firefox.enable = mkForce false;

    # Wrap the program to force using ephemeral profile
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "firefox-wrapped-er";
	paths = [cfg.package];
	nativeBuildInputs = [pkgs.makeWrapper];
	postBuild = ''
	  wrapProgram $out/bin/firefox \
	  --add-flags '--profile' \
	  --add-flags '${profileDir}'
	'';
      })
    ];

    environment.etc = {
      "firefox/policies/policies.json".source = policyFormat.generate "firefox-policies.json" {
        policies = import ./policies.nix {inherit cfg lib pkgs;} // cfg.extraPolicies;
      };
    };

    # Create ephemeral firefox profile
    systemd.tmpfiles.rules = let
      userChrome = packages.simplefox-userChrome.override {
        inherit (cfg.theme.colors) backgroundDark background border;
	inherit (cfg.theme) font extraUserChrome;
      };

      userContent = packages.simplefox-userContent.override {
        inherit (cfg.theme) extraUserContent;
      };

    in [
      "d  ${profileDir}                        0777 root root -   -" 
      "L+ ${profileDir}/chrome/userChrome.css  -    -    -    -   ${userChrome}"
      "L+ ${profileDir}/chrome/userContent.css -    -    -    -   ${userContent}"
    ];
  };
}
