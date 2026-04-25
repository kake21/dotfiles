# Main configuration file that imports other modules.

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/desktop.nix
    ./modules/nvidia.nix
    ./modules/wivrn.nix
    ./modules/steam.nix
    ./modules/stylix.nix
    ./modules/docker.nix
    ./modules/tailscale.nix
    ./modules/ssh.nix
    ./modules/sunshine.nix
    ./modules/star-citizen.nix
  ];
}

