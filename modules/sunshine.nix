{ pkgs, ... }:

{
  # Enable Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Required for KMS grabbing/virtual display
    openFirewall = true;
  };

  # Sunshine needs uinput for virtual input devices
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

  # Add Sunshine to systemPackages for CLI access/management if needed
  environment.systemPackages = [ pkgs.sunshine ];
}
