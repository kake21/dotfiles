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
Declare an option under the `my.*` namespace and read it from Home Manager as
`osConfig.my.*`. Prefer this over comparing hostname strings:
```nix
# modules/options.nix
options.my.shell.bar.enable = lib.mkOption { type = lib.types.bool; default = false; };
# hosts/laptop/configuration.nix
my.shell.bar.enable = true;
# home-manager/modules/shell.nix
cfg = osConfig.my.shell;
```

**Important:** options the *shared* HM profile reads must be declared in
`modules/options.nix`, which `mkDesktopHost` imports for every desktop host.
Declaring such an option inside a feature module that only some hosts import
makes the other hosts fail to evaluate.

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
- Central theme source: `modules/stylix.nix` (hand-written base16, accent `base0D`)
- Auto-applies to: Firefox, Wofi, kitty via `(lib.stylix.colors)` references
- Pattern: `with config.lib.stylix.colors; ''...#${base01}...''`
- vshell mirrors the scheme into a generated `Theme.qml` singleton - change
  colours in `modules/stylix.nix`, never in the QML

### Hyprland + Home-Manager
- Config lives in `home-manager/modules/hyprland.nix`, using the Lua backend
  (`configType = "lua"`): settings are attrs of `_args` lists built with
  `lib.generators.mkLuaInline`, not the old string config
- Display config: `settings.monitor = osConfig.my.hyprland.monitors`, set per host
- Keybindings: `settings.bind`, each `{ _args = [ "SUPER + F" (exec "firefox") ]; }`
  using the `exec`/`dsp` helpers at the top of the file
- Startup commands go in the `on hyprland.start` hook, not `exec-once`

### vshell (Quickshell desktop shell)
- Replaces Waybar. Bar + quick settings panel in one process
- Nix layer: `home-manager/modules/shell.nix` generates `Theme.qml` (from Stylix)
  and `Config.qml` (from `osConfig.my.shell` + store paths for every external
  binary), merges them with the static tree, and wires `programs.quickshell`
- QML lives in `home-manager/shell/`; it is *not* generated - edit it directly
- Runs as a systemd user service bound to `graphical-session.target`
- Panel opens with `SUPER+ALT+SPACE` (`qs -c vshell ipc call quicksettings toggle`)
- Bar is opt-in per host via `my.shell.bar.enable` (currently laptop only);
  the panel is on everywhere
- Sections hide themselves when their hardware is absent, so the same config
  works on desktops with no battery/backlight/Bluetooth

### Known rough edge: `xc`
`xc` runs the shared HM Hyprland profile but does not import
`modules/hyprland.nix`, so it has no system-level Hyprland, greetd, or portals.
It needs `environment.pathsToLink` set by hand to satisfy Home Manager's
`xdg.portal` assertion. Either import the module or stop running the Hyprland
profile there - the current state is half-configured.

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
| `modules/options.nix` | `my.*` option declarations; imported by `mkDesktopHost` for all desktop hosts |
| `home-manager/home.nix` | User (vegard) configuration: Hyprland, apps, theming |
| `home-manager/modules/shell.nix` | Generates the vshell QML config and wires `programs.quickshell` |
| `home-manager/shell/**.qml` | vshell source: `shell.qml`, `Bar.qml`, `QuickSettings.qml`, `bar/`, `panel/`, `components/` |
| `modules/nixvim.nix`, `modules/obsidian.nix` | Home-manager-specific modules |
| `build.log` | Build output logs (git-ignored) |
| `update.sh` | Quick rebuild script (customize hostname) |

