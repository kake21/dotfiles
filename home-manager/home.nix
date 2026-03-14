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
          "HDMI-A-1, 5120x1440@60.00,0x0,1"
          "DP-4,3840x2160@60,640x-2160,1"
          "eDP-1,1920x1080@59.988,-1920x360,1"
          #"DP-5,5120x1440@60.00,1920x0,1"
      ];

      input = {
          kb_layout = "no";
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
        layout = "dwindle";
      };

      exec-once = [
        "hyprsunset"
      ];

      decoration = {
        rounding = 16;
      };

      master = {
          new_status = "master";
          mfact = 0.5;
          orientation = "center";
      };

      workspace = [
          "1, monitor:HDMI-A-1, default:true, layout:master"
          "2, monitor:DP-4, layout:dwindle"
          "3, monitor:eDP-1, layout:dwindle"
      ];

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

          # Media keys (using pamixer and playerctl)
          ", XF86AudioRaiseVolume, exec, pamixer -i 1"
          ", XF86AudioLowerVolume, exec, pamixer -d 1"
          ", XF86AudioMute, exec, pamixer -t"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioMicMute, exec, pamixer --default-source -t"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];

      bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.firefox.profiles.vegard = {
    search = {
      default = "DuckDuckGo";
    };
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

  xdg.configFile."hypr/hyprsunset.conf".text = ''
      max-gamma = 150

      profile {
          time = 07:30
          identity = true
      }

      profile {
          time = 19:00
          temperature = 3700
          gamma = 0.8
      }
  '';


    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          type = "builtin";
          source = [
            "::::.    ':::::      ::::"
            "::::'      :::::     ::::"
            "::::.        :::::   ::::"
            "::::'          ::::: ::::"
            "::::.            ::::::::"
            "::::'          ::::: ::::"
            "::::.        :::::   ::::"
            "::::'      :::::     ::::"
            "::::.    :::::       ::::"
          ];
          padding.right = 2;
        };

        display = {
          separator = "  ";
          color = "blue";
          size.maxPrefix = "GB";
        };

        modules = [
          "title"
          "separator"

          "os"
          "host"
          "kernel"
          "uptime"
          "packages"

          "shell"
          "terminal"
          "terminalfont"

          "de"
          "wm"
          "wmtheme"

          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"

          "battery"
          "poweradapter"

          "locale"
          "break"
          "colors"
        ];
      };
    };

}