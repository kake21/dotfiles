#!/usr/bin/env bash
# Back up or restore a host's SSH host key via sops.
#
#   scripts/sops-hostkey.sh backup  [host]   # run ON the host (needs sudo)
#   scripts/sops-hostkey.sh restore [host]   # run ON the host (needs sudo)
#
# These files are encrypted to the admin key only: a host cannot decrypt its
# own host key using that same key. That is why this is a deliberate manual
# step rather than something activation does.
set -euo pipefail

cd "$(dirname "$0")/.."

mode="${1:?usage: sops-hostkey.sh <backup|restore> [host]}"
host="${2:-$(hostname)}"
file="secrets/hostkeys/${host}.yaml"
key=/etc/ssh/ssh_host_ed25519_key

sops() { nix run --inputs-from . nixpkgs#sops -- "$@"; }

case "$mode" in
  backup)
    [ -r "$key" ] || { echo "cannot read $key -- run with sudo -E or as root" >&2; exit 1; }
    tmp=$(mktemp); trap 'rm -f "$tmp"' EXIT
    {
      echo "# SSH host key backup for ${host}. Admin-key only, restored by hand:"
      echo "#   scripts/sops-hostkey.sh restore ${host}"
      echo "ssh_host_ed25519_key: |"
      sed 's/^/    /' "$key"
      echo "ssh_host_ed25519_key_pub: |"
      sed 's/^/    /' "${key}.pub"
    } > "$tmp"
    cp "$tmp" "$file"
    sops --encrypt --in-place "$file"
    echo "backed up ${host} host key -> ${file}"
    ;;

  restore)
    [ -f "$file" ] || { echo "no backup at $file" >&2; exit 1; }
    install -d -m 755 /etc/ssh
    sops --decrypt --extract '["ssh_host_ed25519_key"]' "$file" > "$key"
    sops --decrypt --extract '["ssh_host_ed25519_key_pub"]' "$file" > "${key}.pub"
    chmod 600 "$key"; chmod 644 "${key}.pub"
    echo "restored ${host} host key. Now: systemctl restart sshd"
    ;;

  *) echo "unknown mode: $mode (expected backup or restore)" >&2; exit 1 ;;
esac
