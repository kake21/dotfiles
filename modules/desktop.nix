{ config, pkgs, inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.bspwm.enable = true;

  # Enable greetd window manager.
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --time --remember --cmd ${config.services.displayManager.defaultSession}";
        user = "greeter";
      };
      initial_session = {
        command = "${config.services.displayManager.defaultSession}";
        user = "vegard";
      };
    };
  };

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };

  users.groups.greeter = {};
  
  # Enable power management
  services.upower.enable = true;
  
  # Enable gnome-keyring for secret storage (needed by spot, etc.)
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;
  security.pam.services.sxhkd.enableGnomeKeyring = true;

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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # nvidia-x11 legacy driver). Support is limited to the Turing and later 
    # architectures. Full list of supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/experimental and may be unstable.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  programs.noisetorch.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # kdePackages.plasma-workspace
    bspwm
    sxhkd
    rofi
    polybar
    # gnome-tweaks
    #sidequest
    alvr
    android-tools
    nvtopPackages.nvidia
    #inkscape
    prismlauncher
    git
    peaclock
    hyprshot
    slurp
    #jdk25_headless
    hyprpicker
    obsidian
    #mission-center
    unzip
    #(blender.override {
    #  cudaSupport = true;
    #})
    bluez
    nodejs
    btop
    cava
    nvidia-vaapi-driver
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
    #freecad
    heroic
    #solaar
  ];
}
