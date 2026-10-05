{ config, lib, pkgs, ... }:

let
  cfg = config.my.secrets;
in
{
  imports = [ ./sops.nix ];

  config = lib.mkMerge [
    {
      # Enable the Tailscale service.
      services.tailscale.enable = true;

      # Optionally, you can add Tailscale to systemPackages if you want to use the CLI.
      environment.systemPackages = [ pkgs.tailscale ];
    }

    # Unattended tailnet join. Off by default: a host that is already
    # authenticated keeps its existing node identity, and re-running `up`
    # with a stale key just logs an error.
    (lib.mkIf (cfg.enable && cfg.tailscale.autoConnect) {
      sops.secrets."tailscale/authkey" = {
        mode = "0400";
        restartUnits = [ "tailscaled-autoconnect.service" ];
      };

      services.tailscale.authKeyFile = config.sops.secrets."tailscale/authkey".path;
    })
  ];
}
