{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cmake
    gcc
    hidapi
    pkg-config
    jstest-gtk
    openconnect
    git
    peaclock
    unzip
    btop
    cava
    vulkan-tools
    mesa
    vim
    wget
    pamixer
    feh
  ];

  # Enable NetworkManager Applet (provides nm-applet and nm-connection-editor)
  programs.nm-applet.enable = true;

  # Enable the NetworkManager OpenConnect plugin globally
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];
}
