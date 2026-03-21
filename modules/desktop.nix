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

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    lug-helper
    hyprpicker
    obsidian
    mission-center
    unzip
    (blender.override {
      cudaSupport = true;
    })
    blender
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
    spotify
    signal-desktop
    freecad
    heroic
    kdePackages.spectacle
    solaar
  ];
}
