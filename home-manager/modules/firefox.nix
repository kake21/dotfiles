{ config, pkgs, ... }:
let
  profileUserName = "vegard";

  lock-false = {
		Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" ];

    profiles.${profileUserName} = {
      isDefault = true;

      extensions = {
				force = true;
			};

      search = {
        force          = true;
        default        = "ddg";
        privateDefault = "ddg";

        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query";   value = "{searchTerms}"; }
                ];
              }
            ];
            icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
      };
    };

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;

      ExtensionSettings = {
        # uBlock Origin
      	"uBlock0@raymondhill.net" = {
      	  install_url = "https://addons.mozilla.org/firefox/downloads/file/4872816/ublock_origin-1.72.0.xpi";
					installation_mode = "force_installed";
				};

				# Proton Pass
				"78272b6fa58f4a1abaac99321d503a20@proton.me" = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/4817795/proton_pass-1.37.1.xpi";
					installation_mode = "force_installed";
				};

				# Sponsorblock
				"sponsorBlocker@ajay.app" = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/4870235/sponsorblock-6.1.6.xpi";
					installation_mode = "force_installed";
				};
      };

      Preferences = {
				"browser.formfill.enable" = lock-false;
			};
    };
  };
}
