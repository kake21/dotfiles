{ config, lib, pkgs, ... }:

let
  cfg = config.my.secrets;
  user = config.my.username;
  home = config.users.users.${user}.home;

  # Public keys are not secrets -- they live in the clear so that every host
  # gets them on rebuild, including hosts not yet enrolled in sops.
  adminKeys = [
    # ~/.ssh/id_ed25519 on vex; private half is in secrets/common.yaml
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+kvX1z1dawNCsC4NwL9Euf4ZsWdRJz069R7wdhyJnt vegard@admin"
  ];

  # A secret file owned by the primary user, optionally symlinked into place.
  userSecret = path: { owner = user; mode = "0400"; } // lib.optionalAttrs (path != null) { inherit path; };
in
{
  imports = [ ./sops.nix ];

  config = lib.mkMerge [
    {
      # Enable the OpenSSH daemon.
      services.openssh = {
        enable = true;
        settings = {
          # Key-only. mkDefault so a host can opt back in if it has to;
          # console and serial login still use the password, so a bad key
          # is not a lockout.
          PasswordAuthentication = lib.mkDefault false;
          KbdInteractiveAuthentication = lib.mkDefault false;
          AllowUsers = null; # Allow all users or specify here
          UseDns = true;
          X11Forwarding = false;
          PermitRootLogin = lib.mkDefault "no"; # "no", "yes", "without-password", "prohibit-password"
        };
      };

      users.users.${user}.openssh.authorizedKeys.keys = adminKeys;

      # Root accepts the same key: `nixos-rebuild --target-host root@...` and
      # the distributed-build setup in useremote.nix both need it.
      users.users.root.openssh.authorizedKeys.keys = adminKeys;

      # Open ports in the firewall.
      networking.firewall.allowedTCPPorts = [ 22 ];
    }

    # Private key material, delivered only to hosts enrolled in sops.
    (lib.mkIf cfg.enable {
      sops.secrets = {
        # Admin keypair, so any of my own machines can reach the others.
        "ssh/vegard_ed25519_key" = userSecret "${home}/.ssh/id_ed25519";

        # Per-project keys for the NTNU hosts. Kept here so a reinstall
        # restores a working ~/.ssh instead of needing a manual copy.
        "ssh/auctionen_key" = userSecret "${home}/.ssh/auctionen.key";
        "ssh/contactor_key" = userSecret "${home}/.ssh/contactor.key";
        "ssh/vevcom_key" = userSecret "${home}/.ssh/vevcom.key";

        # Host blocks for servers whose addresses should not be in git.
        # Pulled in via programs.ssh.includes in home-manager/modules/ssh.nix,
        # so it stays at its default /run/secrets path.
        "ssh/client_config" = userSecret null;
      };
    })
  ];
}
