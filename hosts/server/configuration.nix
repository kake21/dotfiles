{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Specific to vex
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
    ../../modules/ssh.nix
  ];

  networking.hostName = "nix-server";
}
