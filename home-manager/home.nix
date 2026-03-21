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

  programs.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "QT_QPA_PLATFORM,wayland;xcb"
        "GDK_BACKEND,wayland,x11,*"
      ];


      misc = {
        vrr = 0;
      };

      render = {
        direct_scanout = 0;
      };

      cursor = {
        no_hardware_cursors = false;
      };

      monitor = [
          "DP-2, 5120x1440@240.00, 0x0, 1"
          "DP-3, 3840x2160@59.99700, 640x-2160, 1"
          "HEADLESS-2, 2800x1752@60, 2048x1440, 2"
          #"HDMI-A-1, 5120x1440@60.00,0x0,1"
          #"DP-4,3840x2160@60,640x-2160,1"
          #"eDP-1,1920x1080@59.988,-1920x360,1"
          #"DP-5,5120x1440@60.00,1920x0,1"
      ];

      input = {
        kb_layout = "no";
        follow_mouse = 1;
        accel_profile = "flat";
        sensitivity = 0;
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 0;
        layout = "dwindle";
        allow_tearing = false;
      };

      exec-once = [
        "hyprctl output create headless"
        "hyprsunset"
        "waybar"
      ];

      decoration = {
        rounding = 16;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };

      master = {
          new_status = "master";
          mfact = 0.5;
          orientation = "center";
      };

      workspace = [
          "1, monitor:DP-2, default:true, layout:master"
          "2, monitor:DP-3, layout:dwindle"
          "3, monitor:HEADLESS-1, layout:dwindle"
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
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"
          "$mod, ESCAPE, exec, hyprlock"

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

      device = [
        {
          name = "pen-passthrough";
          output = "HEADLESS-2";
        }
        {
          name = "touch-passthrough-1";
          output = "HEADLESS-2";
        }
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

  programs.kitty = {
    enable = true;
  };

  gtk.enable = true;

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