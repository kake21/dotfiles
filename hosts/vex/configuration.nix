{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Specific to vex
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
    ../../modules/wivrn.nix
    ../../modules/steam.nix
    ../../modules/stylix.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
    ../../modules/ssh.nix
    ../../modules/sunshine.nix
    # ../../modules/star-citizen.nix
    ../../modules/remote.nix
  ];

  networking.hostName = "vex";

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

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xrandr}/bin/xrandr --output DP-2 --mode 5120x1440 --rate 240 --primary
    ${pkgs.xrandr}/bin/xrandr --output DP-4 --mode 3840x2160 --pos 640x-2160
  '';
}
