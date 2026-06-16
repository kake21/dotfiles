{ config, lib, pkgs, ... }:

{
  options.my.username = lib.mkOption {
    type = lib.types.str;
    description = "Primary username";
  };

  config = {
    users.users.${config.my.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "input" ];
      initialPassword = "changeme";
    };
  };
}