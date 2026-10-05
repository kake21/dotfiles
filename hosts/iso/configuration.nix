{ config, lib, pkgs, modulesPath, ... }:

# Graphical installer ISO, themed and keybound like the daily-driver hosts so
# an install feels the same as the installed system.
#
# Two deliberate omissions from the desktop host recipe:
#
#   * modules/system.nix is NOT imported -- it enables systemd-boot, which
#     makes no sense for an ISO. The safe parts (locale, keymap, nix settings)
#     are replicated locally, the same way hosts/lxc does it.
#   * modules/desktop.nix is NOT imported -- it pulls in gui-apps.nix
#     (spotify, freecad, heroic, chromium ...). Its useful halves (audio,
#     fonts, cli-apps, base-desktop) are imported directly instead.
#
# Secrets are intentionally absent: an ISO's host key is generated at boot, so
# it can never be a sops recipient, and an install image is a distributable
# artifact. `my.secrets.enable` stays false and only the *public* admin key
# ships, via modules/ssh.nix.

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"

    ../../modules/users.nix
    ../../modules/base-desktop.nix
    ../../modules/audio.nix
    ../../modules/fonts.nix
    ../../modules/cli-apps.nix
    ../../modules/stylix.nix
    ../../modules/hyprland.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
  ];

  networking.hostName = "nixos-installer";
  my.username = "vegard";

  # Cannot be enrolled: the host key does not exist until boot. Explicit
  # rather than relying on the default, because getting this wrong would ship
  # private keys inside the image.
  my.secrets.enable = false;

  # Worth the strip of screen on an installer -- network and battery state
  # matter while partitioning.
  my.shell.bar.enable = true;

  # modules/ssh.nix wants "no"; profiles/installation-device.nix wants "yes".
  # Both are mkDefault, so they conflict at equal priority -- force it.
  services.openssh.settings.PermitRootLogin = lib.mkForce "no";

  # Replicated from modules/system.nix, minus the bootloader.
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Install-time tooling: enough to partition, clone this repo, and bring a
  # new host's secrets online without fetching anything first.
  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
    gptfdisk
    parted
    cryptsetup
    rsync
    nixos-install-tools
  ];

  image.fileName = "nixos-installer.iso";
}
