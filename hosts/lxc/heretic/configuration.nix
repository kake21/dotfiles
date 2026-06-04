{ pkgs, config, lib, ... }:

{
  imports = [
    ../configuration.nix
  ];

  networking.hostName = "heretic";

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = lib.mkForce false;
    powerManagement.enable = false;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "0.0.0.0";
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    btop
    linuxPackages.nvidia_x11
  ];
}
