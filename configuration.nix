# Main configuration file that imports other modules.

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system.nix
    ./modules/networking.nix
    ./modules/users.nix
    ./modules/desktop.nix
  ];
}

