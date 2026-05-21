{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vegard = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "input" ]; # Enable ‘sudo’ for the user.
    initialPassword = "changeme";
    packages = with pkgs; [
      tree
    ];
  };
}
