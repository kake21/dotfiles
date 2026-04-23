{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Loadkeys
  console.keyMap = "no";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Enable unfree licenses
  nixpkgs.config.allowUnfree = true;

  # Enable nix-ld to run pre-compiled binaries (e.g., JetBrains Remote Development)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glib
    libx11
    libxext
    libxrender
    libxinerama
    libxi
    libxcursor
    libxcomposite
    libxdamage
    libxfixes
    libxrandr
    libxtst
    freetype
    fontconfig
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    gtk3
    libGL
    libxcrypt
    libxkbcommon
    mesa
    nspr
    nss
    pango
    udev
    libdrm
    libxshmfence
    libv4l
    icu # Added for JetBrains
    libsecret # Added for JetBrains
  ];

  # This value defines the first version of NixOS you have installed on this particular machine.
  system.stateVersion = "25.11";
}
