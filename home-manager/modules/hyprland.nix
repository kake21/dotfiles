{ inputs, lib, pkgs, osConfig, ... }:
let
  mod = "SUPER";
  inline = lib.generators.mkLuaInline;
  dsp = cmd: inline "hl.dsp.${cmd}";
  exec = cmd: dsp "exec_cmd(${builtins.toJSON cmd})";
  moveFocus = dir: dsp "focus({ direction = ${builtins.toJSON dir} })";
  moveWindow = dir: dsp "window.move({ direction = ${builtins.toJSON dir} })";
  resize = x: y: dsp "window.resize({ x = ${toString x}, y = ${toString y}, relative = true })";
  gotoWorkspace = n: dsp "focus({ workspace = ${toString n} })";
  moveToWorkspace = n: dsp "window.move({ workspace = ${toString n} })";
in
{
  programs.hyprlock.enable = true;

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

  wayland.windowManager.hyprland = {
    enable = true;

    configType = "lua";

    settings = {
      env = map (e: { _args = [ e.name e.value ]; }) [
        { name = "LIBVA_DRIVER_NAME"; value = "nvidia"; }
        { name = "XDG_SESSION_TYPE"; value = "wayland"; }
        { name = "GBM_BACKEND"; value = "nvidia-drm"; }
        { name = "__GLX_VENDOR_LIBRARY_NAME"; value = "nvidia"; }
        { name = "NVD_BACKEND"; value = "direct"; }
        { name = "ELECTRON_OZONE_PLATFORM_HINT"; value = "auto"; }
        { name = "QT_QPA_PLATFORM"; value = "wayland;xcb"; }
        { name = "GDK_BACKEND"; value = "wayland,x11,*"; }
      ];

      config = {
        misc = {
          vrr = 0;
        };

        render = {
          direct_scanout = 0;
        };

        cursor = {
          no_hardware_cursors = false;
        };

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

        general = {
          gaps_in = 2;
          gaps_out = 2;
          border_size = 0;
        };

        decoration = {
          rounding = 8;
          blur = {
            enabled = true;
            size = 8;
            passes = 2;
          };
        };

        gestures = {
          workspace_swipe_invert = true;
          workspace_swipe_distance = 300;
        };
      };

      monitor = osConfig.my.hyprland.monitors;

      workspace_rule = [
        { workspace = "1"; monitor = "DP-2"; }
        { workspace = "2"; monitor = "DP-3"; }
      ];

      # Ignore maximize requests from apps - a lot of GTK/Electron apps
      # request "maximize" on startup, which Hyprland otherwise honors by
      # tiling them to fill the whole workspace (looks like fullscreen).
      window_rule = {
        match.class = ".*";
        suppress_event = "maximize";
      };

      # Runs once on startup, replacing the old exec-once list.
      # (The dbus-update-activation-environment/systemctl handover line is
      # already generated separately by the systemd.enable integration below.)
      on = {
        _args = [
          "hyprland.start"
          (inline ''
            function()
              hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY")
              hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY")
              hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
              hl.exec_cmd("hyprsunset")
              hl.exec_cmd("nm-applet --indicator")
              hl.exec_cmd("waybar")
            end
          '')
        ];
      };

      bind =
        [
          { _args = [ "${mod} + F" (exec "firefox") ]; }
          { _args = [ "${mod} + Q" (exec "kitty") ]; }
          { _args = [ "${mod} + R" (exec "wofi --show drun") ]; }

          # Screenshot
          { _args = [ "${mod} + SHIFT + S" (exec "hyprshot -m region") ]; }
          { _args = [ "Print" (exec "hyprshot -m region") ]; }
          { _args = [ "ALT + Print" (exec "hyprshot -m window") ]; }
          { _args = [ "CTRL + Print" (exec "hyprshot -m output") ]; }

          # Colorpicker
          { _args = [ "${mod} + SHIFT + C" (exec "hyprpicker -a") ]; }

          { _args = [ "${mod} + C" (dsp "window.close()") ]; }
          { _args = [ "${mod} + M" (dsp "exit()") ]; }
          { _args = [ "${mod} + SPACE" (dsp "window.float({ action = \"toggle\" })") ]; }

          # Focus movement (vim style)
          { _args = [ "${mod} + H" (moveFocus "left") ]; }
          { _args = [ "${mod} + J" (moveFocus "down") ]; }
          { _args = [ "${mod} + K" (moveFocus "up") ]; }
          { _args = [ "${mod} + L" (moveFocus "right") ]; }
          { _args = [ "${mod} + ESCAPE" (exec "hyprlock") ]; }

          # Move windows
          { _args = [ "${mod} + SHIFT + H" (moveWindow "left") ]; }
          { _args = [ "${mod} + SHIFT + L" (moveWindow "right") ]; }
          { _args = [ "${mod} + SHIFT + K" (moveWindow "up") ]; }
          { _args = [ "${mod} + SHIFT + J" (moveWindow "down") ]; }

          # Resize windows
          { _args = [ "${mod} + CTRL + H" (resize (-60) 0) ]; }
          { _args = [ "${mod} + CTRL + L" (resize 60 0) ]; }
          { _args = [ "${mod} + CTRL + K" (resize 0 (-60)) ]; }
          { _args = [ "${mod} + CTRL + J" (resize 0 60) ]; }

          # Fullscreen
          { _args = [ "${mod} + RETURN" (dsp "window.fullscreen()") ]; }

          # Mouse move/resize
          { _args = [ "${mod} + mouse:272" (dsp "window.drag()") { mouse = true; } ]; }
          { _args = [ "${mod} + mouse:273" (dsp "window.resize()") { mouse = true; } ]; }

          # Media keys (using pamixer and playerctl)
          { _args = [ "XF86AudioRaiseVolume" (exec "pamixer -i 1") ]; }
          { _args = [ "XF86AudioLowerVolume" (exec "pamixer -d 1") ]; }
          { _args = [ "XF86AudioMute" (exec "pamixer -t") ]; }
          { _args = [ "XF86AudioPlay" (exec "playerctl play-pause") ]; }
          { _args = [ "XF86AudioNext" (exec "playerctl next") ]; }
          { _args = [ "XF86AudioPrev" (exec "playerctl previous") ]; }
          { _args = [ "XF86AudioMicMute" (exec "pamixer --default-source -t") ]; }
          { _args = [ "XF86MonBrightnessUp" (exec "brightnessctl set 5%+") ]; }
          { _args = [ "XF86MonBrightnessDown" (exec "brightnessctl set 5%-") ]; }
        ]
        # Workspaces
        ++ map
          (n: {
            _args = [ "${mod} + ${toString (lib.mod n 10)}" (gotoWorkspace n) ];
          })
          (lib.range 1 10)
        ++ map
          (n: {
            _args = [ "${mod} + SHIFT + ${toString (lib.mod n 10)}" (moveToWorkspace n) ];
          })
          (lib.range 1 10);

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

      # hyprexpo isn't loaded (plugin block below is disabled), so its
      # gesture binding isn't ported - it wasn't functional before either.
      gesture = [
        { fingers = 3; direction = "horizontal"; action = "workspace"; }
      ];

      # hyprexpo = {
      #   columns = 3;
      #   gap_size = 5;
      #   bg_col = "rgb(111111)";
      #   workspace_method = "center current";
      #   gesture_distance = 300;
      # };
    };
  };
}
