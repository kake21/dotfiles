{ osConfig, ... }:

{
  home = {
    username = osConfig.my.username;
    homeDirectory = "/home/${osConfig.my.username}";
    stateVersion = "26.05";
  };

  # Lets Stylix generate and auto-apply a Plasma look-and-feel package
  # (colors, widget style, window decorations) from the system theme
  # in modules/stylix.nix. stylix.targets.kde.enable defaults to true.
  stylix.enable = true;
}
