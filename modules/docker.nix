{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  # Optionally, you can enable rootless mode or other settings here.
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
