{ lib, modulesPath, pkgs, ... }:

{
  imports = [
    # NixOS integration for Proxmox LXC guests.
    "${modulesPath}/virtualisation/proxmox-lxc.nix"

    ../../modules/users.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
  ];

  networking.hostName = "lxc";

  # Avoid NetworkManager in containers; Proxmox provides networking.
  networking.networkmanager.enable = lib.mkForce false;
  networking.useDHCP = lib.mkDefault true;

  # Common base settings kept local to avoid bootloader options from system.nix.
  time.timeZone = "Europe/Berlin";
  console.keyMap = "no";

  i18n.defaultLocale = "nb_NO.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  system.stateVersion = "25.11";
}

