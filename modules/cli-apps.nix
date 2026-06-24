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
    fd
    tree-sitter
    ripgrep
    pamixer
    feh
    spotify-player
    github-copilot-cli
    (azure-cli.withExtensions [
      azure-cli.extensions.bastion
      azure-cli.extensions.ssh
    ])
  ];

  # Enable NetworkManager Applet (provides nm-applet and nm-connection-editor)
  programs.nm-applet.enable = true;

  # Enable the NetworkManager OpenConnect plugin globally
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];
}
