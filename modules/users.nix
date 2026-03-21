{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vegard = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    initialPassword = "changeme";
    packages = with pkgs; [
      tree
    ];
  };

  # Set up Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # Note: The actual home configuration is imported in flake.nix
}
