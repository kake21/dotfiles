{ config, pkgs, ... }:

{
  imports = [
    ./base-desktop.nix
    ./audio.nix
    ./fonts.nix
    ./gui-apps.nix
    ./cli-apps.nix
  ];

  services.xserver = {
    enable = true;
    xkb.layout = "no";
  };
}
