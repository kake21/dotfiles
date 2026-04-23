# Vex NixOS Configuration

This repository contains the NixOS configuration for my personal machine `vex`. It's a Flake-based setup using Hyprland, Stylix, and Home Manager.

## Features
- **Window Manager:** Hyprland (Wayland)
- **Terminal:** Kitty
- **Shell:** Bash (standard)
- **Theme:** Stylix (auto-theming everything)
- **Gaming:** Steam, Heroic, Star Citizen (via `nix-citizen`)
- **System:** Nvidia drivers, Pipewire, Systemd-boot

## Installation Guide for Beginners

This guide assumes you are booting from a NixOS ISO and have a basic understanding of the command line.

### 1. Partitioning (UEFI/GPT)

Identify your disk (e.g., `/dev/nvme0n1` or `/dev/sda`) using `lsblk`. Replace `/dev/sdX` with your actual disk name.

```bash
# Start partitioning
sudo parted /dev/sdX -- mklabel gpt
sudo parted /dev/sdX -- mkpart ESP fat32 1MiB 513MiB
sudo parted /dev/sdX -- set 1 esp on
sudo parted /dev/sdX -- mkpart primary ext4 513MiB 100%

# Formatting partitions
sudo mkfs.fat -F 32 -n boot /dev/sdX1
sudo mkfs.ext4 -L nixos /dev/sdX2
```

### 2. Mounting Partitions

```bash
# Mount root
sudo mount /dev/disk/by-label/nixos /mnt

# Mount boot
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### 3. Cloning the Repository

```bash
# Install git if not present on the ISO
nix-shell -p git

# Clone this repo into /mnt/etc/nixos (or your preferred location)
sudo git clone https://github.com/YOUR_USERNAME/dotfiles.git /mnt/etc/nixos
cd /mnt/etc/nixos
```

**Important:** Update the user and hostname in the configuration if you plan to change them. Currently, it's set to:
- **Hostname:** `vex`
- **User:** `vegard`

### 4. Hardware Configuration

The repo contains a `hardware-configuration.nix` for a specific machine. You should generate your own to ensure it matches your hardware (especially if using different filesystems or disk layouts).

```bash
sudo nixos-generate-config --root /mnt --no-filesystems
# Review /mnt/etc/nixos/hardware-configuration.nix and merge or replace the existing one.
```

### 5. Installing NixOS

```bash
sudo nixos-install --flake .#vex
```

### 6. Finishing Up

1. Set a password for your user: `sudo nixos-enter --root /mnt -c 'passwd vegard'`
2. Reboot: `sudo reboot`

## Post-Installation

After logging in, you can apply changes by running:

```bash
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#vex
```

## Maintenance

- **Update Flake Lock:** `nix flake update`
- **Garbage Collection:** `nix-collect-garbage -d`