cd "$(dirname "$0")/.." || exit
nix build .#nixosConfigurations.lxc.config.system.build.tarball