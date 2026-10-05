{ config, lib, inputs, ... }:

let
  cfg = config.my.secrets;
in
{
  # Pulled in here rather than from the flake's host builders so that any host
  # importing ssh.nix or tailscale.nix gets the option declarations it needs,
  # with no per-host import churn. Nix dedupes imports by path, so the three
  # modules importing each other is fine.
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.my.secrets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Decrypt secrets/common.yaml on this host.

        Requires the host to be a recipient in .sops.yaml -- run
        `scripts/sops-add-host.sh <host>` first, or activation fails with
        "no key could decrypt the data".
      '';
    };

    tailscale.autoConnect = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Join the tailnet unattended using the auth key from
        secrets/common.yaml. Leave off for hosts already authenticated;
        turn on for fresh installs so they come up on the tailnet.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../secrets/common.yaml;

      # The host decrypts using its own OpenSSH host key, converted to age
      # in-memory by sops-nix. Nothing extra to provision on a host that
      # already has an ed25519 host key -- which is every host here.
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      # The host key is not managed by sops (see secrets/hostkeys/), so there
      # is no generated age key to fall back to.
      age.generateKey = false;
    };
  };
}
