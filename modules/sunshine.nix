{ pkgs, ... }:

{
  # Enable Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Required for KMS grabbing/virtual display
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };

    settings = {
      audio_sink = "sink-sunshine-stereo";
      # Target the 3rd Wayland monitor (Index 2)
      # This will map to whatever HEADLESS-* monitor Hyprland creates
      output_name = "2";
    };

    applications = {
      env = {
        PATH = "${pkgs.hyprland}/bin:${pkgs.jq}/bin:${pkgs.bash}/bin:${pkgs.coreutils}/bin:${pkgs.pulseaudio}/bin";
      };
      apps = [
        {
          name = "Desktop (Headless)";
          exclude-gpu = false;
          prep-cmd = [
            {
              do = "${pkgs.writeShellScript "sunshine-prep" ''
                # Export Hyprland instance signature
                export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/$(id -u)/hypr/ | head -n 1)

                WIDTH=''${SUNSHINE_CLIENT_WIDTH:-1920}
                HEIGHT=''${SUNSHINE_CLIENT_HEIGHT:-1080}
                FPS=''${SUNSHINE_CLIENT_FPS:-60}

                # Set resolution
                ${pkgs.hyprland}/bin/hyprctl keyword monitor "HEADLESS-2, ''${WIDTH}x''${HEIGHT}@''${FPS}, auto, 1"

                # Move to the headless monitor
                ${pkgs.hyprland}/bin/hyprctl dispatch focusmonitor "$MONITOR"

                # Create a virtual sink for audio if it doesn't exist
                if ! ${pkgs.pulseaudio}/bin/pactl list sinks short | grep -q "sink-sunshine-stereo"; then
                    ${pkgs.pulseaudio}/bin/pactl load-module module-null-sink sink_name=sink-sunshine-stereo sink_properties=device.description=Sunshine-Stereo
                fi

                # Move workspaces to new headless monitor
                ${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 1 "$MONITOR"
                ${pkgs.hyprland}/bin/hyprctl dispatch movecurrentworkspacetomonitor "$MONITOR"
                ${pkgs.hyprland}/bin/hyprctl dispatch workspace 1

                # Wait a bit for things to settle
                sleep 0.5
              ''}";
              undo = "${pkgs.writeShellScript "sunshine-undo" ''
                # Export Hyprland instance signature
                export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/$(id -u)/hypr/ | head -n 1)

                if [ -f /tmp/sunshine-headless-monitor ]; then
                  MONITOR=$(cat /tmp/sunshine-headless-monitor)
                  rm /tmp/sunshine-headless-monitor
                else
                  MONITOR=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.name | startswith("HEADLESS")) | .name' | tail -n 1)
                fi

                if [ -n "$MONITOR" ]; then
                  ${pkgs.hyprland}/bin/hyprctl output remove "$MONITOR"
                fi

                # Remove the virtual sink
                SINK_ID=$(${pkgs.pulseaudio}/bin/pactl list modules | grep -B 1 "sink_name=sink-sunshine-stereo" | grep "Module #" | awk '{print $2}' | tr -d '#')
                if [ -n "$SINK_ID" ]; then
                  ${pkgs.pulseaudio}/bin/pactl unload-module "$SINK_ID"
                fi
              ''}";
            }
          ];
        }
      ];
    };
  };

  # Sunshine needs uinput for virtual input devices
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

  # Add Sunshine to systemPackages for CLI access/management if needed
  environment.systemPackages = [
    (pkgs.sunshine.override { cudaSupport = true; })
  ];
}