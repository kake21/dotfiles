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
    ../../modules/llama-cpp.nix
  ];

  networking.hostName = "xc";
  my.username = "vegard";

  # xc runs the shared Home Manager Hyprland profile (which enables xdg.portal
  # on the user side) but does not import modules/hyprland.nix, so nothing
  # enables portals system-wide and Home Manager's assertion fires. vex and
  # laptop get these paths for free from that module. See the note in
  # AGENTS.md: xc's Hyprland setup is only half-configured.
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

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
