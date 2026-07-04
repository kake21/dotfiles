{ config, osConfig, ... }:
{
  programs.waybar = {
    enable = osConfig.networking.hostName != "vex";

    settings = {
      mainBar = {
        layer = "bottom";
        position = "bottom";

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "pulseaudio"
          "network"
          "bluetooth"
          "battery"
          "battery#wattage"
        ];

        clock = {
          format = "{:%H:%M}";
        };

        cpu = {
          format = " {icon}";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
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
          format-wifi = " {essid}";
          format-ethernet = "󰈀 Connected";
          format-disconnected = "󰖪 Disconnected";
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };

          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = " {capacity}%";

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

        "battery#wattage" = {
          format = "{power:.1f}W";
          tooltip = false;
        };
      };
    };

    style = with config.lib.stylix.colors; ''
      #cpu,
      #pulseaudio,
      #network,
      #bluetooth,
      #battery,
      #wattage {
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
}
