{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    chromium
    bitwarden-desktop
    spotify
    signal-desktop
    inkscape
    prismlauncher
    mission-center
    pavucontrol
    playerctl
    brightnessctl
    kitty
    freecad
    heroic
    ollama
    obsidian
  ];

  # Enable gnome-keyring for secret storage (needed by spot, etc.)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;
}
