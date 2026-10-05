#!/usr/bin/env bash
# Enroll a host as a sops recipient so it can decrypt secrets/common.yaml.
#
#   scripts/sops-add-host.sh <hostname> [ssh-target]
#
# Fetches the host's ed25519 SSH host key over ssh-keyscan, converts it to an
# age recipient, adds an anchor to .sops.yaml, and re-encrypts the shared
# secrets to include it. Then set `my.secrets.enable = true;` in that host's
# configuration.nix and rebuild it.
set -euo pipefail

cd "$(dirname "$0")/.."

host="${1:?usage: sops-add-host.sh <hostname> [ssh-target]}"
target="${2:-$host}"

run() { nix run --inputs-from . "nixpkgs#$1" -- "${@:2}"; }

echo "==> scanning host key of ${target}"
pub=$(ssh-keyscan -t ed25519 "$target" 2>/dev/null | grep -m1 ' ssh-ed25519 ' | cut -d' ' -f2-)
[ -n "$pub" ] || { echo "no ed25519 host key from ${target}" >&2; exit 1; }

age_key=$(printf '%s\n' "$pub" | run ssh-to-age)
[ -n "$age_key" ] || { echo "ssh-to-age produced nothing" >&2; exit 1; }
echo "    ${host} -> ${age_key}"

anchor="host_${host//[^a-zA-Z0-9_]/_}"

if grep -q "&${anchor} " .sops.yaml; then
  echo "==> ${anchor} already in .sops.yaml, leaving rules alone"
else
  echo "==> adding &${anchor} to .sops.yaml"
  # Append the anchor after the last existing host anchor in the keys: block.
  awk -v anchor="$anchor" -v key="$age_key" '
    /^  - &host_/ { last = NR }
    { lines[NR] = $0 }
    END {
      for (i = 1; i <= NR; i++) {
        print lines[i]
        if (i == last) printf "  - &%s %s\n", anchor, key
      }
    }
  ' .sops.yaml > .sops.yaml.new && mv .sops.yaml.new .sops.yaml

  # Add it as a recipient of the shared file.
  awk -v anchor="$anchor" '
    index($0, "path_regex") && index($0, "common") { in_common = 1 }
    in_common && /^          - \*host_/ { last = NR }
    { lines[NR] = $0 }
    END {
      for (i = 1; i <= NR; i++) {
        print lines[i]
        if (i == last) printf "          - *%s\n", anchor
      }
    }
  ' .sops.yaml > .sops.yaml.new && mv .sops.yaml.new .sops.yaml
fi

echo "==> re-encrypting secrets/common.yaml to the new recipient set"
run sops updatekeys --yes secrets/common.yaml

echo
echo "Done. Next:"
echo "  1. set 'my.secrets.enable = true;' in hosts/${host}/configuration.nix"
echo "  2. sudo nixos-rebuild switch --flake .#${host}"
