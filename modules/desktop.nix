{ config, pkgs, inputs, ... }:

{
  services.displayManager.defaultSession = "none+bspwm";
  services.xserver = {
    enable = true;
    xkb.layout = "no";

    displayManager.lightdm = {
      enable = true;
      greeters.slick.enable = true;
    };

    # Tiling window manager
    windowManager.bspwm = {
      enable = true;
      # Configuration handled by home-manager
    };
  };

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xrandr}/bin/xrandr --output DP-2 --mode 5120x1440 --rate 240 --primary
    ${pkgs.xrandr}/bin/xrandr --output DP-4 --mode 3840x2160 --pos 640x-2160
  '';

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };
  services.picom = {
      enable = true;
      vSync = true;
    };

  # Enable power management
  services.upower.enable = true;
  
  # Enable gnome-keyring for secret storage (needed by spot, etc.)
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;

  # Enable XDG portals for Hyprland and others
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-xapp
    ];
    config.common.default = "*";
  };

  # Enable wayland (Hyprland)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    discordo
    spotify-player
    rofi
    inkscape
    prismlauncher
    git
    peaclock
    hyprshot
    slurp
    #jdk25_headless
    hyprpicker
    mission-center
    unzip
    #(blender.override {
    #  cudaSupport = true;
    #})
    bluez
    nodejs
    btop
    cava
    hyprsunset
    pavucontrol
    playerctl
    brightnessctl
    vulkan-tools
    mesa
    jetbrains-mono
    discord
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    wl-clipboard
    mako
    pamixer
    noto-fonts
    feh
    # adwaita-icon-theme
    vim
    wget
    kitty
    jetbrains.webstorm
    jetbrains.idea
    #jetbrains.rider
    #mono
    spotify
    signal-desktop
    freecad
    heroic
    #solaar
  ];
}
