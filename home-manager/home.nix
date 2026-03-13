{ inputs, pkgs, ... }:
{
  home.username = "vegard";
  home.homeDirectory = "/home/vegard";

  # Set Norwegian keyboard for Wayland (Hyprland)
  home.sessionVariables = {
    # GTK apps, general apps
    XKB_DEFAULT_LAYOUT = "no";
  };

  home.stateVersion = "25.11";

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

    monitor = [
        "eDP-1,1920x1080@59.988,0x0,1"
    ];

    input = {
      kb_layout = "no";
    };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
      };
      decoration = {
        rounding = 10;
      };
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, Q, exec, kitty"
          "$mod, R, exec, wofi --show drun"
          ", Print, exec, grimblast copy area"

          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, V, togglefloating"
          "$mod, P, pseudo" # dwindle
          "$mod, J, togglesplit"

          # Focus movement (vim style)
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          # Move windows
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"

          # Resize windows
          "$mod CTRL, H, resizeactive, -60 0"
          "$mod CTRL, L, resizeactive, 60 0"
          "$mod CTRL, K, resizeactive, 0 -60"
          "$mod CTRL, J, resizeactive, 0 60"

          # Fullscreen
          "$mod, RETURN, fullscreen"

        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
    };
  };

  programs.firefox.profiles.vegard = {
    extensions.packages = with pkgs.firefoxExtensions; [
      ublock-origin
      darkreader
    ];
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    font = {
      name = "Sans";
      size = 11;
    };
  };
}