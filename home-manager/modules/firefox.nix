{ config, pkgs, ... }:
let
  profileUserName = "vegard";
in
{
  programs.firefox = {
    enable = true;

    configPath = "${config.xdg.configHome}/mozilla/firefox";

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
    };
  };
}
