{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
  ];
}
