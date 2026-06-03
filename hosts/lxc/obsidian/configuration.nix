{ pkgs, lib, ... }:

{
  imports = [
    ../configuration.nix
  ];

  networking.hostName = "lxc-obsidian";

  # Obsidian LiveSync (CouchDB) default port.
  networking.firewall.allowedTCPPorts = [ 5984 ];

  # Use the NixOS couchdb service module (packaged as couchdb3) which sets up
  # users, directories and command-line correctly for the Erlang runtime.
  services.couchdb = {
    enable = true;
    package = pkgs.couchdb3;
    # Listen on all interfaces so you can reach it from other machines on the LAN.
    bindAddress = "0.0.0.0";
    port = 5984;
    # Set a simple admin; replace with a secure secret (don't commit to git).
    adminPass = "changeme";
    # Ensure the data directory (module will manage ownership) — keep default
    # or explicitly set if desired:
    # dataDir = "/var/lib/couchdb";
  };
}