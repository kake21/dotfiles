{ config, lib, osConfig, ... }:

let
  secrets = osConfig.my.secrets;

  # Written by sops-nix (see modules/ssh.nix). Holds the Host blocks for
  # servers whose hostnames and addresses should not end up in git.
  secretConfig = "/run/secrets/ssh/client_config";
in
{
  programs.ssh = {
    enable = true;

    # Opt out of Home Manager's legacy implicit `Host *` block and spell out
    # below only what we actually want.
    enableDefaultConfig = false;

    # Include first: ssh takes the first value it obtains for each keyword,
    # so the encrypted blocks win over the defaults below.
    includes = lib.optional secrets.enable secretConfig;

    # Non-sensitive hosts only -- my own machines, reachable over the tailnet.
    settings = {
      "nvex" = {
        HostName = "nvex";
        User = "vegard";
      };
      "laptop" = {
        HostName = "laptop";
        User = "vegard";
      };
      "*" = {
        IdentityFile = "~/.ssh/id_ed25519";
        ServerAliveInterval = 60;
        AddKeysToAgent = "yes";
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };
    };
  };
}
