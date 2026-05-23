{ config, inputs, lib, pkgs, osConfig, ... }:
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

  programs.waybar = {
    enable = osConfig.networking.hostName == "laptop";

    settings = {
      mainBar = {
        layer = "bottom";
        position = "bottom";

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "bluetooth"
          "battery"
        ];

        clock = {
          format = "{:%H:%M}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 muted";

          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 Connected";
          format-disconnected = "󰖪 Disconnected";
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected =
            "{device_enumerate}";

          tooltip-format-enumerate-connected =
            "{device_alias}\t{device_address}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };

          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = " {capacity}%";

          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
      };
    };

    style = with config.lib.stylix.colors;''
      #pulseaudio,
      #network,
      #bluetooth,
      #battery {
        background: #${base01};
        padding: 0 8px;
        margin: 4px 2px;
        border-radius: 8px;
      }
      .modules-right {
        margin-right: 2px;
      }
    '';
  };


  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      inputs.hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3
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
        "QT_QPA_PLATFORM,wayland;xcb"        "GDK_BACKEND,wayland,x11,*"
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
          "DP-2, 5120x1440@240, 0x0, 1"
          "DP-3, 3840x2160@59.99700, 640x-2160, 1"
      ];

      input = {
        kb_layout = "no";
        follow_mouse = 1;
        accel_profile = "flat";
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.2;
        };
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      gestures = {
        workspace_swipe_invert = true;
        workspace_swipe_distance = 300;
      };

      general = {
        gaps_in = 2;
        gaps_out = 2;
        border_size = 0;
      };

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY"
        "gnome-keyring-daemon --start --components=secrets"
        #"hyprctl output create headless"
        "hyprsunset"
        "nm-applet --indicator"
        "waybar"
      ];

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };


      workspace = [
          "1, monitor:DP-2"
          "2, monitor:DP-3"
      ];

      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, Q, exec, kitty"
          "$mod, R, exec, wofi --show drun"

          # Screenshot
          "$mod SHIFT, S, exec, hyprshot -m region"
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
      wofi.enable = false;
    };
  };

  # BPSWM
  #xsession.windowManager.bspwm = {
  #  enable = true;
  #  monitors = {
  #    DP-2 = [ "1" "2" "3" "4" "5" ];
  #    DP-3 = [ "6" "7" "8" "9" "0" ];
  #  };
  #  settings = {
  #    border_width = 2;
  #    window_gap = 4;
  #    split_ratio = 0.52;
  #  };
  #  startupPrograms = [
  #    #"xrandr --output DP-2 --mode 5120x1440 --rate 240 --pos 0x0 --rotate normal --output DP-4 --mode 3840x2160 --pos 640x-2160 --rotate normal"
  #    "feh --bg-fill /home/vegard/dotfiles/modules/wallpapers/Hawk_PirateView_Concept.jpg"
  #  ];
  #};

  #services.sxhkd = {
  #  enable = true;
  #  keybindings = {
  #    "super + q" = "kitty";
  #    "super + r" = "wofi --show drun";
  #    "super + c" = "bspc node -c";
  #    "super + m" = "bspc quit";
  #    "super + alt + {q,r}" = "bspc {quit,wm -r}";
  #
  #    # pocus/swap
  #    "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
  #
  #    # Focus the next/previous window in the current desktop
  #    "super + {_,shift + }c" = "bspc node -f {next,prev}.local.!hidden.window";
  #
  #    # Focus the next/previous desktop in the current monitor
  #    "super + {bracketleft,bracketright}" = "bspc desktop -f {prev,next}.local";
  #
  #    # Focus the last node/desktop
  #    "super + {Tab,grave}" = "bspc {node,desktop} -f last";
  #
  #    # Move to workspace
  #    "super + {1-9,0}" = "bspc desktop -f '^{1-9,10}'";
  #    "super + shift + {1-9,0}" = "bspc node -d '^{1-9,10}'";
  #
  #    # Media keys
  #    "XF86AudioRaiseVolume" = "pamixer -i 1";
  #    "XF86AudioLowerVolume" = "pamixer -d 1";
  #    "XF86AudioMute" = "pamixer -t";
  #    "XF86AudioPlay" = "playerctl play-pause";
  #    "XF86AudioNext" = "playerctl next";
  #    "XF86AudioPrev" = "playerctl previous";
  #    "XF86MonBrightnessUp" = "brightnessctl set +5%";
  #    "XF86MonBrightnessDown" = "brightnessctl set 5%-";

  #    # Preselect
  #    "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
  #    "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
  #    "super + ctrl + space" = "bspc node -p cancel";

  #    # Toggle states
  #    "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
  #  };
  #};

  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      width = 800;
    };
    style = with config.lib.stylix.colors; ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14pt;
      }

      window {
        background-color: #${base00};
        padding: 4px;
        border-radius: 16px;
      }

      #input {
        margin: 10px;
        padding: 8px;
        border-radius: 8px;
        background-color: #${base02};
        color: #cdd6f4;
        border: none;
      }

      #inner-box {
        background-color: transparent;
      }

      #outer-box {
        background-color: transparent;
      }

      #scroll {
        background-color: transparent;
      }

      #text {
        margin: 4px;
        color: #${base0A};
      }

      #entry:selected {
        background-color: #${base02};
        border-radius: 8px;
      }

      #text:selected {
        color: #${base0A};
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

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.7"; # adjust (0.0–1.0)
      confirm_os_window_close = 0;
    };
  };

  xdg.configFile."hypr/hyprsunset.conf".text = ''
      max-gamma = 150

      profile {
          time = 07:30
          identity = true
      }

      profile {
          time = 22:00
          temperature = 3700
          gamma = 1
      }
  '';


  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "${pkgs.writeText "fastfetch-logo.txt" ''
                                        🭈🬭🭆🬹🭂
                                  🭈🬭🭆🬹🭂██████
                            🭈🬭🭆🬹🭂████████████
                      🭈🬭🭆🬹🭂██████████████████
                🭈🬽  🭧🬎🭓██████████████████████
          🭈🬭🭆🬹🭂████🭍🬹🭑🬭🬽🭣🬂🭧🬎🭓████████████████
          ███████████████🭍🬹🭑🬭🬽🭣🬂🭧🬎🭓█████🭞🬎🭜🬂🭘
          █████████████████████🭍🬹🭑🬭 🭣🬂🭘
          ██████████████████🭞🬎🭜🬂🭘$2🭈🬭🭆🬹🬹🭑🬭🬽$1
          ████████████🭞🬎🭜🬂🭘$2🭈🬭🭆🬹🭂████████🭞$1
          ██████🭞🬎🭜🬂🭘$2🭈🬭🭆🬹🭂█████████🭞🬎🭜🬂🭘$1🭈🬭🭆🬹🭂
          🭞🬎🭜🬂🭘$2🭈🬭🭆🬹🭂█████████🭞🬎🭜🬂🭘$1🭈🬭🭆🬹🭂██████
              $2🭂████████🭞🬎🭜🬂🭘$1🭈🬭🭆🬹🭂████████████
              $2🭣🬂🭧🬎🬎🭜🬂🭘$1🭈🬭🭆🬹🭂██████████████████
                🭈🬭🬽 🬂🭧🬎🭓█████████████████████
          🭈🬭🭆🬹🭂█████🭍🬹🭑🬭🬽🭣🬂🭧🬎🭓███████████████
          ████████████████🭍🬹🭑🬭🬽🭣🬂🭧🬎🭓████🭞🬎🭜🬂🭘
          ██🭜🭘vex  🭣🭧███████████🭍🬹🭑  🭣🭘
          ██🭑🬽NixOS🭈🭆███████🭞🬎🭜🬂🭘
          ████████████🭞🬎🭜🬂🭘
          ██████🭞🬎🭜🬂🭘
          🭞🬎🭜🬂🭘

        ''}";
        type = "file";

        color = {
          "1" = "blue";
          "2" = "magenta";
        };

        padding = {
          top = 1;
          left = 2;
          right = 3;
        };
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

  imports = [ 
    inputs.nixcord.homeModules.nixcord
    ../modules/nixvim.nix
  ];
    programs.nixcord = {
      enable = true;

      # Choose your client (enable only one of these two)
      discord.vencord.enable = true;      # Standard Vencord
      # discord.equicord.enable = true;   # Equicord (has more plugins)

      # Or these
      vesktop.enable = true;
      # dorion.enable = true;
      # legcord.enable = true;

      # Theming
      quickCss = "/* css goes here */";
      config = {
        useQuickCss = true;
        themeLinks = [
          "https://raw.githubusercontent.com/link/to/some/theme.css"
        ];
        frameless = true;
      };
    };
}