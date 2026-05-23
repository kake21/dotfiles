{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix # You'll need to generate this on the laptop
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/desktop.nix
    ../../modules/stylix.nix
    ../../modules/tailscale.nix
    ../../modules/ssh.nix
    ../../modules/nvidia.nix
  ];

  networking.hostName = "laptop";

  # Nvidia PRIME
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # GeForce MX250 is supported through the 580.xx Legacy drivers on recent NixOS
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

  # Laptop specific settings
  services.libinput.enable = true; # Enable touchpad support
  
  # Enable Ollama
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  # Power management
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}
