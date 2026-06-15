{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/desktop.nix
    ../../modules/stylix.nix
    ../../modules/tailscale.nix
    ../../modules/ssh.nix
    ../../modules/nvidia.nix
    ../../modules/useremote.nix
    ../../modules/kde.nix
  ];

  networking.hostName = "hulve";
  my.username = "torbjorn";

  # Laptop specific settings
  services.libinput.enable = true; # Enable touchpad support

  # Power management
  powerManagement.enable = true;
  services.thermald.enable = true;

  # Better CPU power management
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # TLP for other power optimizations (disabled CPU management to avoid conflict with auto-cpufreq)
  services.tlp = {
    enable = true;
    settings = {
      # Radio devices
      # DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth"; # Optional
      
      # Battery charge thresholds (ThinkPad specific usually, but good to have)
      # START_CHARGE_THRESH_BAT0 = 75;
      # STOP_CHARGE_THRESH_BAT0 = 80;

      # Enable audio power saving
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      
      # Enable wifi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  # Power consumption monitoring and auto-tuning
  powerManagement.powertop.enable = true;

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
}
