{ config, pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
  ];

  # Use GNOME for a user-friendly desktop environment in the ISO.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    git
    jetbrains.webstorm
    # Include some basics to make WebStorm usable
    firefox 
  ];

  # Nix configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree for WebStorm
  nixpkgs.config.allowUnfree = true;

  # Allow networkmanager to handle everything, but we don't need to enable it explicitly
  # as it's enabled by default in the graphical installation CD.
  # Explicitly setting it can cause conflicts with other ISO-specific networking settings.

  # Set a label for the ISO
  isoImage.isoName = "nixos-webstorm-installer.iso";

  # Squashfs compression can be slow, but makes it smaller.
  # For a "small" ISO, this is usually default, but we can be explicit if needed.
  # isoImage.squashfsCompression = "gzip -Xcompression-level 1"; # Faster but bigger
}
