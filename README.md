# NixOS Configuration

This repository contains the NixOS configuration for my personal machines.

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
- **Hostname:** `vex`, `laptop`, `lxc` and more
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

## Secrets (sops-nix)

Secrets are committed to this repo **encrypted** with [sops](https://github.com/getsops/sops)
and [age](https://github.com/FiloSottile/age), and decrypted on each host at
activation time. See `modules/sops.nix`.

### How decryption works

Each host decrypts using its own `/etc/ssh/ssh_host_ed25519_key`, converted to
an age identity by sops-nix. Nothing extra needs provisioning on a host that
already has an ed25519 host key. You decrypt with the admin key in
`~/.config/sops/age/keys.txt`.

> **Back up `~/.config/sops/age/keys.txt`.** It is the only key that can read
> every secret. Lose it and the only remaining readers are the hosts
> themselves.

### Layout

| Path | Contents |
|------|----------|
| `.sops.yaml` | Recipient rules: who can decrypt what |
| `secrets/common.yaml` | Tailscale auth key, admin SSH keypair, per-project SSH keys, private SSH client config |
| `secrets/hostkeys/<host>.yaml` | Host SSH host-key backups, admin-key only |

### Editing a secret

```bash
nix run nixpkgs#sops -- secrets/common.yaml
```

This opens the decrypted file in `$EDITOR` and re-encrypts on save. Only the
values are encrypted, so the key names stay readable in diffs.

### Enrolling a new host

A host must be a recipient before it can decrypt anything, or activation fails
with `no key could decrypt the data`:

```bash
scripts/sops-add-host.sh <hostname>          # host must be reachable over ssh
# then set `my.secrets.enable = true;` in hosts/<hostname>/configuration.nix
sudo nixos-rebuild switch --flake .#<hostname>
```

### SSH

`modules/ssh.nix` is key-only (`PasswordAuthentication = false`). The admin
public key is in the clear there, so every host accepts it on rebuild even
before being enrolled in sops. Console and serial login still use the
password, so a bad key is not a lockout.

On enrolled hosts, sops-nix symlinks the private keys into place:

| Secret | Appears at |
|--------|-----------|
| `ssh/vegard_ed25519_key` | `~/.ssh/id_ed25519` |
| `ssh/auctionen_key` | `~/.ssh/auctionen.key` |
| `ssh/contactor_key` | `~/.ssh/contactor.key` |
| `ssh/vevcom_key` | `~/.ssh/vevcom.key` |
| `ssh/client_config` | `/run/secrets/ssh/client_config` |

`ssh/client_config` holds the `Host` blocks for servers whose hostnames and
addresses should not be in git. `home-manager/modules/ssh.nix` pulls it in with
`programs.ssh.includes`, placed first so those blocks win over the plaintext
`Host *` defaults. Add a public, non-sensitive host to `matchBlocks` there;
add a private one by editing the secret.

### Host SSH host keys

`secrets/hostkeys/<host>.yaml` is encrypted to the admin key **only** — a host
cannot decrypt its own host key using that same key. These are a backup so a
reinstalled host keeps its identity (and everyone else's `known_hosts` keeps
working), restored by hand:

```bash
sudo -E scripts/sops-hostkey.sh backup   # run on the host, writes the backup
sudo -E scripts/sops-hostkey.sh restore  # on a reinstall, before enrolling
```

### Tailscale

`my.secrets.tailscale.autoConnect = true` makes a host join the tailnet
unattended using `tailscale/authkey` from `secrets/common.yaml`. Leave it off
for hosts that are already authenticated — they keep their node identity, and
re-running `up` with a stale key just logs an error. Turn it on for fresh
installs.
