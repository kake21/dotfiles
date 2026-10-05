{ config, inputs, lib, pkgs, osConfig, ... }:

# Lean Home Manager profile for the installer ISO.
#
# Reuses the same Hyprland/vshell/kitty/wofi/mako modules as the daily-driver
# profile in home.nix, so the keybindings and look carry over to the live
# environment. Deliberately omits the heavy desktop apps (obsidian, spicetify,
# nixcord/vesktop) and the Firefox profile -- the installer base already ships
# Firefox, and none of that belongs in an install medium.
{
  home = {
    username = osConfig.my.username;
    homeDirectory = "/home/${osConfig.my.username}";
    stateVersion = "26.05";

    sessionVariables = {
      XKB_DEFAULT_LAYOUT = "no";
      HYPRSHOT_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };

  stylix.enable = true;

  imports = [
    ./modules/hyprland.nix
    ./modules/shell.nix
    ./modules/mako.nix
    ./modules/wofi.nix
    ./modules/kitty.nix
    ./modules/fastfetch.nix
    ./modules/ssh.nix
  ];
}
