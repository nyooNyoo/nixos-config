{ 
  config, 
  pkgs,
  packages,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.types) listOf attrsOf oneOf enum bool int str;
  inherit (extensions) mkExtensions;

  profileDir = "/var/lib/firefox/default/profile";

  policyFormat = pkgs.formats.json {};
  extensions = import ./extensions.nix {inherit config lib;};

  cfg = config.modules.programs.firefox;
in {
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

    extensions = mkOption {
      type = listOf (enum extensions.list);
      default = ["ublock-origin"];
      description = ''
        List of firefox extensions available in the mozilla store by their
	short id (found in the download url).
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

    environment.etc = let
      policiesJSON = policyFormat.generate "firefox-policies.json" {
	# Default security policies
	policies = import ./preferences.nix {inherit pkgs;} // 
	  # Install extensions and language-packs
	  {ExtensionSettings = mkExtensions cfg.extensions cfg.languagePacks false;} //
	  # User defined extras.
	  cfg.extraPolicies;
      };
    in {
      "firefox/policies/policies.json".source = policiesJSON;
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
