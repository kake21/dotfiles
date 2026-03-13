{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb.layout = "no";

  # Enable ly window manager.
  services.displayManager.ly.enable = true;
  
  # Enable power management
  services.upower.enable = true;

  # Enable wayland (Hyprland)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    fastfetch
    jetbrains-mono
    discord
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    wl-clipboard
    grim
    mako
    pamixer
    noto-fonts
    vim
    wget
    kitty
    jetbrains.webstorm
    wofi
    firefox
    steam
    spotify
    signal-desktop
    tailscale
    freecad
    heroic
    kdePackages.spectacle
    solaar
  ];
}
