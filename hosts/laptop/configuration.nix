{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # ./hardware-configuration.nix # You'll need to generate this on the laptop
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/desktop.nix
    ../../modules/stylix.nix
    ../../modules/tailscale.nix
    ../../modules/ssh.nix
  ];

  networking.hostName = "laptop";

  # Laptop specific settings
  services.libinput.enable = true; # Enable touchpad support
  
  # Enable Ollama
  services.ollama = {
    enable = true;
  };

  # Power management
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;
}
