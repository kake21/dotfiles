{ config, pkgs, inputs, ... }:

{
  # services.displayManager.defaultSession = "none+bspwm";
  services.displayManager.defaultSession = "hyprland";
  services.xserver = {
    enable = true;
    xkb.layout = "no";

    # displayManager.lightdm = {
    #   enable = true;
    #   greeters.slick.enable = true;
    # };

    # Tiling window manager
    # windowManager.bspwm = {
    #   enable = true;
    #   # Configuration handled by home-manager
    # };s
  };

  # Enable greetd window manager.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --time --remember --cmd start-hyprland";
        user = "greeter";
      };
      initial_session = {
        command = "start-hyprland";
        user = "vegard";
      };
    };
  };

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };

  users.groups.greeter = {};

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
  security.pam.services.greetd.enableGnomeKeyring = true;
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

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "start-hyprland" ''
      export LIBVA_DRIVER_NAME=nvidia
      export XDG_SESSION_TYPE=wayland
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1
      exec Hyprland
    '')
    (pkgs.ollama.override {
      acceleration = "cuda";
    })
    bitwarden-desktop
    discordo
    spotify-player
    wofi
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
