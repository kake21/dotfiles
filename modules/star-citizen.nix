{ config, pkgs, inputs, ... }: {
  # Avoids building wine-astral (and friends) from source locally.
  nix.settings = {
    substituters = [ "https://nix-citizen.cachix.org" ];
    trusted-public-keys = [ "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=" ];
  };

  # nix-citizen's rsi-launcher module. Handles the system-level requirements
  # Star Citizen needs to not crash on Linux (was previously just installing
  # the raw launcher package with none of this applied):
  #   - vm.max_map_count = 16777216 (SC mmaps far more regions than the
  #     kernel default of 65530/1048576 allows; too-low values are the most
  #     common cause of random crashes/freezes)
  #   - fs.file-max + a raised nofile ulimit
  #   - snd-aloop/v4l2loopback kernel modules, ntsync if kernel >= 6.14
  #   - udev rules for joysticks/HOTAS
  programs.rsi-launcher = {
    enable = true;
    preCommands = ''
      export DXVK_HUD=compiler
      export MANGO_HUD=1
    '';
  };
}
