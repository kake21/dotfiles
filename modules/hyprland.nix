{ config, pkgs, inputs, ... }:

{
  # Enable wayland (Hyprland)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  # Enable XDG portals for Hyprland and others
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-xapp
    ];
    config.common.default = "*";
  };

  # Enable greetd window manager.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --time --remember --cmd start-hyprland";
        user = "greeter";
      };
      initial_session = {
        command = "start-hyprland";
        user = "vegard";
      };
    };
  };

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };

  users.groups.greeter = {};

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "start-hyprland" ''
      export XDG_SESSION_TYPE=wayland
      export WLR_NO_HARDWARE_CURSORS=1
      exec Hyprland
    '')
    hyprlauncher
    hyprshot
    slurp
    hyprpicker
    hyprsunset
    wl-clipboard
  ];
}
