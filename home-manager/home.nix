{ config, inputs, pkgs, ... }:
{
  # Home Manager Configuration
  home = {
    username = "vegard";
    homeDirectory = "/home/vegard";
    stateVersion = "25.11";

    # Session Variables
    sessionVariables = {
      # Set Norwegian keyboard for Wayland (Hyprland)
      XKB_DEFAULT_LAYOUT = "no";
    };
  };

  programs.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      inputs.hy3.packages.${pkgs.system}.hy3
    ];

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
          #"DP-3, 1920x1200@59.88, 640x-2160, 1"
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
        layout = "hy3";
        gaps_in = 2;
        gaps_out = 2;
        border_size = 0;
      };

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY"
        "gnome-keyring-daemon --start --components=secrets"
        "hyprctl output create headless"
        "hyprsunset"
        "waybar"
        "hyprctl keyword workspace 2,layout:dwindle"
        "noisetorch -i"
      ];

      decoration = {
        rounding = 16;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };


      workspace = [
          "1, monitor:DP-2"
          "2, monitor:DP-3"
          "3, monitor:HEADLESS-1"
      ];

      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, Q, exec, kitty"
          "$mod, R, exec, wofi --show drun --allow-images"

          # Screenshot
          ", Print, exec, hyprshot -m region"
          "ALT, Print, exec, hyprshot -m window"
          "CTRL, Print, exec, hyprshot -m output"

          # Colorpicker
          "$mod SHIFT, C, exec, hyprpicker -a"

          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, SPACE, togglefloating"

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

  programs.firefox = {
    enable = true;

    profiles = {
      vegard = {
        extensions.force = true;
        search = {
          default = "ddg";
          force = true;
        };
      };
    };
  };

  stylix = {
    enable = true;
    targets = {
      firefox = {
        enable = true;
        profileNames = [ "vegard" ];
        colorTheme.enable = true;
      };
    };
  };

  programs.kitty = {
    enable = true;
  };

  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 600;
      height = 400;
      always_parse_args = true;
      show_all = false;
      print_command = true;
      insensitive = true;
      prompt = "Search...";
    };

    style = with config.lib.stylix.colors; ''
      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 14px;
      }

      window {
        background-color: #${base00};
        padding: 4px;
      }

      #input {
        margin: 10px;
        padding: 8px;
        border-radius: 8px;
        border: none;
        background-color: #${base02};
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: #${base02};
        color: #${base0A};
        padding: 4px;
        border-radius: 8px;
      }
    '';
  };

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
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