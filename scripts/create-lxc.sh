#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/.." || exit

# Default to 'lxc' if no argument provided
LXC_NAME="${1:-lxc}"

# Map friendly names to flake config paths
case "$LXC_NAME" in
  lxc)
    FLAKE_PATH=".#nixosConfigurations.lxc.config.system.build.tarball"
    ;;
  obsidian)
    FLAKE_PATH=".#nixosConfigurations.lxc-obsidian.config.system.build.tarball"
    ;;
  heretic)
    FLAKE_PATH=".#nixosConfigurations.lxc-heretic.config.system.build.tarball"
    ;;
  *)
    echo "Unknown LXC: $LXC_NAME"
    echo "Available options: lxc, obsidian, heretic"
    exit 1
    ;;
esac

echo "Building $LXC_NAME LXC tarball..."
nix build "$FLAKE_PATH"
