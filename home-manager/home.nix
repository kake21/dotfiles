{ config, inputs, lib, pkgs, osConfig, ... }:
let
  profileUserName = "vegard";
in
{
  home = {
    username = "vegard";
    homeDirectory = "/home/vegard";
    stateVersion = "26.05";

    sessionVariables = {
      XKB_DEFAULT_LAYOUT = "no";
      HYPRSHOT_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      OPENAI_BASE_URL = "http://localhost:9292/v1";
    };
  };

  stylix = {
    enable = true;
    targets = {
      firefox = {
        enable = true;
        profileNames = [ profileUserName ];
        colorTheme.enable = true;
      };
      spicetify.enable = true;
      wofi.enable = false;
    };
  };

  programs.spicetify.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  programs.nixcord = {
    enable = true;

    vesktop.enable = true;

    config = {
      frameless = true;
    };
  };

  obsidian.enable = true;

  imports = [
    inputs.nixcord.homeModules.nixcord
    inputs.spicetify-nix.homeManagerModules.default
    ../modules/nixvim.nix
    ../modules/obsidian.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/mako.nix
    ./modules/firefox.nix
    ./modules/wofi.nix
    ./modules/kitty.nix
    ./modules/fastfetch.nix
  ];
}
