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
    ../../modules/star-citizen.nix
    ../../modules/remote.nix
    ../../modules/hyprland.nix
    ../../modules/jetbrains.nix
    ../../modules/llama-cpp.nix
  ];

  networking.hostName = "vex";
  my.username = "vegard";

  my.hyprland.monitors = [
    { output = "DP-2"; mode = "5120x1440@240"; position = "0x0"; scale = "1"; bitdepth = 10; }
    { output = "DP-3"; mode = "3840x2160@59.99700"; position = "640x-2160"; scale = "1"; }
  ];

  # Nvidia specific environment variables for start-hyprland
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xrandr}/bin/xrandr --output DP-2 --mode 5120x1440 --rate 240 --primary
    ${pkgs.xrandr}/bin/xrandr --output DP-3 --mode 3840x2160 --pos 640x-2160
  '';

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}
