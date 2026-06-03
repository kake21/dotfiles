{ lib, pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allow all users or specify here
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = lib.mkDefault "no"; # "no", "yes", "without-password", "prohibit-password"
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
}
