{ config, lib, pkgs, osConfig, ... }:

let
  cfg = osConfig.my.shell;

  # Stylix font sizes are points; the QML sizes everything in pixels.
  fontPx = builtins.floor (config.stylix.fonts.sizes.desktop * 4 / 3);

  # Stylix is the single source of truth for colour. Mirror the base16 scheme
  # into a QML singleton so the shell tracks modules/stylix.nix automatically,
  # the same way wofi/kitty do.
  themeQml = pkgs.writeText "Theme.qml" (with config.lib.stylix.colors; ''
    pragma Singleton
    import QtQuick
    import Quickshell

    // GENERATED from config.lib.stylix.colors - edit modules/stylix.nix instead.
    Singleton {
        readonly property color bg:      "#${base00}"  // base00
        readonly property color bgAlt:   "#${base01}"  // base01 - panels, pills
        readonly property color sel:     "#${base02}"  // base02 - hover, selection
        readonly property color muted:   "#${base03}"  // base03 - dividers
        readonly property color fgDim:   "#${base04}"  // base04 - secondary text
        readonly property color fg:      "#${base05}"  // base05 - body text
        readonly property color fgBright:"#${base06}"  // base06

        readonly property color err:     "#${base08}"  // base08 - red
        readonly property color warn:    "#${base09}"  // base09 - orange
        readonly property color ok:      "#${base0B}"  // base0B - green
        readonly property color accent:  "#${base0D}"  // base0D - primary accent

        readonly property string fontFamily: "${config.stylix.fonts.sansSerif.name}"
        readonly property string monoFamily: "${config.stylix.fonts.monospace.name}"
        readonly property int    fontSize:   ${toString fontPx}

        // Matches decoration.rounding in home-manager/modules/hyprland.nix.
        readonly property int radius:  8
        readonly property int spacing: 8
        readonly property int padding: 12
    }
  '');

  # Host facts and absolute binary paths. Under systemd the shell does not
  # inherit a useful PATH, so every external command is resolved at build time.
  configQml = pkgs.writeText "Config.qml" ''
    pragma Singleton
    import Quickshell

    // GENERATED from osConfig.my.shell - edit modules/options.nix / the host.
    Singleton {
        readonly property bool   barEnabled:  ${lib.boolToString cfg.bar.enable}
        readonly property string barPosition: "${cfg.bar.position}"
        readonly property string hostName:    "${osConfig.networking.hostName}"

        readonly property int barHeight: 34

        readonly property string brightnessctl: "${lib.getExe pkgs.brightnessctl}"
        readonly property string makoctl:       "${config.services.mako.package}/bin/makoctl"
        readonly property string hyprsunset:    "${lib.getExe pkgs.hyprsunset}"
        readonly property string hyprlock:      "${lib.getExe config.programs.hyprlock.package}"
        readonly property string systemctl:     "${pkgs.systemd}/bin/systemctl"
        readonly property string cat:           "${pkgs.coreutils}/bin/cat"

        // Night light temperature applied when the toggle is on. Note that the
        // time profiles in hypr/hyprsunset.conf (07:30 identity, 22:00 3700K)
        // still fire and will override a manual toggle at those times.
        readonly property int nightTemp: 3700
    }
  '';

  # programs.quickshell.configs takes one path per config, so the static QML
  # tree and the two generated singletons are merged into a single store path.
  # runCommand rather than symlinkJoin: we need to write files *into* the tree.
  vshell = pkgs.runCommand "vshell" { } ''
    mkdir -p $out
    cp -r ${../shell}/. $out/
    chmod -R u+w $out
    cp ${themeQml}  $out/Theme.qml
    cp ${configQml} $out/Config.qml
  '';
in
{
  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      configs.vshell = vshell;
      activeConfig = "vshell";
      # systemd.target defaults to config.wayland.systemd.target
      # (graphical-session.target), which Hyprland already activates because
      # wayland.windowManager.hyprland.systemd.enable is true.
      systemd.enable = true;
    };

    home.packages = with pkgs; [
      brightnessctl
      hyprsunset
    ];
  };
}
