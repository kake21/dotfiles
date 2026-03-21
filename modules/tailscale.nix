{ pkgs, ... }:

{
  # Enable the Tailscale service.
  services.tailscale.enable = true;

  # Optionally, you can add Tailscale to systemPackages if you want to use the CLI.
  environment.systemPackages = [ pkgs.tailscale ];
}
