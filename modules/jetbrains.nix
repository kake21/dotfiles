{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains.webstorm
    jetbrains.idea
    jetbrains.dataspell
    jetbrains.clion
  ];
}
