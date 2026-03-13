{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Loadkeys
  console.keyMap = "no";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable unfree licenses
  nixpkgs.config.allowUnfree = true;

  # This value defines the first version of NixOS you have installed on this particular machine.
  system.stateVersion = "25.11";
}
