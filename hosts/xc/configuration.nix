{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
    ../../modules/steam.nix
    ../../modules/stylix.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
    ../../modules/ssh.nix
    ../../modules/remote.nix
  ];

  networking.hostName = "xc";

  # Nvidia specific environment variables for start-hyprland
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Enable Ollama with CUDA acceleration
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
