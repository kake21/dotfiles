cd "$(dirname "$0")/.."
nix build .#nixosConfigurations.lxc.config.system.build.tarball