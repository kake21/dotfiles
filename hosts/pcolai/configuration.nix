{ config, lib, pkgs, inputs, ... }:

{
  my.username = "nikolai";
  networking.hostName = "pcolai";

  imports = [
    ./hardware-configuration.nix
    ./local-apps.nix
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/desktop.nix
    ../../modules/steam.nix
    ../../modules/stylix.nix
    #../../modules/docker.nix
    ../../modules/tailscale.nix
    ../../modules/ssh.nix
    #../../modules/sunshine.nix
    #../../modules/remote.nix
    ../../modules/kde.nix
  ];

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}