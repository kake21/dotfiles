# NixOS Configuration

This repository contains the NixOS configuration for my personal machines.

## Features
- **Window Manager:** Hyprland (Wayland)
- **Terminal:** Kitty
- **Shell:** Bash (standard)
- **Theme:** Stylix (auto-theming everything)
- **Terminal font:** JetBrainsMonoNFM-Regular

## Installation

Setup partitions and mount them as shown in the NixOS Installation guide:
https://nixos.wiki/wiki/NixOS_Installation_Guide

Recommended to set up swap on systems with less than 32GB of ram.

### 3. Cloning the Repository

```bash
# Install git if not present on the ISO
nix-shell -p git

# Clone this repo into /mnt/etc/nixos (or your preferred location)
sudo git clone https://github.com/kake21/dotfiles.git /mnt/home/USERNAME/dotfiles
cd /mnt/etc/home/USERNAME/dotfiles
```

**Important:** Update the user and hostname in the configuration if you plan to change them. Currently, it's set to:
- **Hostname:** `vex`, `laptop`, and `lxc`
- **Username:** `vegard`
- **Initial Passwd:** `changeme`

### 4. Hardware Configuration

Generate hardware configuration and copy it to your designated host.

```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix ~/dotfiles/hosts/host
```

### 5. Installing NixOS
Replace `host` with the host you are installing.
```bash
sudo nixos-install --flake .#host
```
Reboot and remove installation medium.

## Post-Installation

Remember to change the initial password.
After logging in, you can apply changes by running:

```bash
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#host
```

## Maintenance

- **Update Flake Lock:** `nix flake update`
- **Garbage Collection:** `nix-collect-garbage -d`

## Proxmox LXC Host

Use the `lxc` host profile to build or switch a Proxmox LXC guest configuration:

```bash
sudo nixos-rebuild switch --flake .#lxc
```

## ISO Creation

If you need a portable ISO with WebStorm to install this configuration on a new machine:

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

The resulting ISO will be in `result/iso/`.