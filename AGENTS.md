# AGENTS.md - NixOS Dotfiles Configuration Guide

## Architecture Overview

This is a **flake-based NixOS system configuration** with a host-specific + modular design:

- **Multiple Hosts**: `vex` (desktop), `laptop`, `iso` (installer) defined in `flake.nix`
- **Module System**: Common configuration split into `/modules/*.nix`, imported selectively per host
- **Home-Manager Integration**: Unified user config at `/home-manager/home.nix` (user: `vegard`)
- **Flake Inputs**: External dependencies (nixpkgs, home-manager, hyprland, stylix, nixvim, etc.)

## Key Workflows

### Deployment
```bash
# Apply changes to current system (edit update.sh for hostname)
sudo nixos-rebuild switch --flake .#hostname

# Build ISO for new installations
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

### Maintenance
```bash
# Update all dependencies (nixpkgs, home-manager, etc.)
nix flake update

# Clean old generations
nix-collect-garbage -d

# Generate hardware config on new machine
sudo nixos-generate-config --root /mnt
```

## Project Conventions

### Host-Specific Configuration Pattern
Use `osConfig.networking.hostName` to branch logic (e.g., `home-manager/home.nix:4,24`):
```nix
let isLaptop = osConfig.networking.hostName == "laptop";
in {  services.waybar.enable = osConfig.networking.hostName != "vex";  }
```

### Module Organization
- **System modules** (`modules/*.nix`): System-level, imported in host `configuration.nix`
- **Home-manager modules** (`modules/nixvim.nix`, `modules/obsidian.nix`): User-level, imported in `home-manager/home.nix`
- **Hardware config** (`hosts/{hostname}/hardware-configuration.nix`): Auto-generated, DO NOT edit manually

### Configuration Import Order
Each host's `configuration.nix` imports:
1. Hardware configuration (auto-generated)
2. Base system modules (system.nix, networking.nix, users.nix)
3. Feature modules (desktop.nix, nvidia.nix, docker.nix, etc.)
4. Host-specific settings (display modes, Ollama for vex, etc.)

## Critical Integration Points

### Stylix (Theme Management)
- Central theme source: defined in `flake.nix` inputs
- Auto-applies to: Firefox, Waybar, Wofi, kitty via `(lib.stylix.colors)` references
- Pattern: `with config.lib.stylix.colors; ''...#${base01}...''`

### Hyprland + Home-Manager
- Display config: `wayland.windowManager.hyprland.settings.monitor` in `home-manager/home.nix:179-182`
- Keybindings: `bind` array with `$mod` (SUPER) prefix
- Host-specific touches: Laptop gestures enabled via `lib.optionalAttrs isLaptop` (line 318)

### Hardware-Specific Branching
- **Laptop**: NVIDIA PRIME offloading (legacy_580 driver), power management (auto-cpufreq, tlp)
- **Vex**: NVIDIA direct rendering, Ollama CUDA setup, xrandr display config
- Edit NVIDIA settings in `/modules/nvidia.nix`, power settings in host config

### Nix-LD for Binary Compatibility
- In `modules/system.nix:49-89`: Extensive library setup for running pre-compiled binaries (JetBrains tools)
- **Do not remove** unless switching entirely to Nix-packaged equivalents

## New Feature Addition Checklist

1. **System-level feature** → Create/edit in `/modules/feature.nix`
2. **Multi-host variant** → Add conditional: `imports = [ (lib.mkIf (osConfig.networking.hostName == "vex") ...) ]`
3. **User config** → Add to `/home-manager/home.nix` or create `/modules/yourfeature.nix` and import
4. **Import the module** → Add to appropriate host's `configuration.nix`
5. **Theme integration** → Use `config.lib.stylix.colors` if visual
6. **Test**: `sudo nixos-rebuild switch --flake .#targethost`

## Common Pitfalls

- **Don't edit hardware-configuration.nix** - regenerate with `nixos-generate-config`
- **User is hardcoded as `vegard`** - search and replace if changing
- **Hostname affects config behavior** - check `osConfig.networking.hostName` comparisons
- **Flake outputs** - only 3 hosts defined: update `flake.nix` outputs section to add more
- **Home-manager state**: Set to "25.11" - update when changing NixOS version

## File Reference

| Path | Purpose |
|------|---------|
| `flake.nix` | Dependency inputs, host definitions, output schema |
| `hosts/{hostname}/configuration.nix` | Host-specific system config + module imports |
| `modules/*.nix` | Reusable system configuration modules |
| `home-manager/home.nix` | User (vegard) configuration: Hyprland, apps, theming |
| `modules/nixvim.nix`, `modules/obsidian.nix` | Home-manager-specific modules |
| `build.log` | Build output logs (git-ignored) |
| `update.sh` | Quick rebuild script (customize hostname) |

