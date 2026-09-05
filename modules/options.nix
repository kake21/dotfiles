{ lib, ... }:

# Option declarations for the `my.*` namespace that the shared Home Manager
# profile (home-manager/home.nix) reads via `osConfig.my.*`.
#
# This module is imported by `mkDesktopHost` in flake.nix rather than by
# individual hosts, on purpose: any option the shared HM profile reads must be
# declared on *every* desktop host, or that host stops evaluating. Declaring
# these next to their feature module used to break `xc`, which runs the HM
# Hyprland profile but does not import modules/hyprland.nix.

{
  options.my = {
    hyprland.monitors = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Per-host Hyprland monitor declarations, consumed by home-manager/modules/hyprland.nix.";
    };

    shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable vshell, the Quickshell desktop shell (quick settings panel,
          and optionally a bar). Defaults on for desktop hosts; the panel is
          reachable via SUPER+ALT+SPACE even when the bar is disabled.
        '';
      };

      bar = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Draw the vshell bar. Off by default; opt in per host.";
        };

        position = lib.mkOption {
          type = lib.types.enum [ "top" "bottom" ];
          default = "bottom";
          description = "Screen edge the vshell bar anchors to.";
        };
      };
    };
  };
}
