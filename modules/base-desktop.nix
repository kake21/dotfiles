{ config, pkgs, ... }:

{
  # Graphics / OpenGL
  hardware.graphics.enable = true;

  # Power management
  services.upower.enable = true;

  # DBus and Polkit
  services.dbus.enable = true;
  security.polkit.enable = true;

  # Picom (mostly for X11, but included in original desktop.nix)
  services.picom = {
    enable = true;
    vSync = true;
  };
}
