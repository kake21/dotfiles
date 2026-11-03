{ config, pkgs, ... }:

{
  # azure-cli needs fabric, which is marked broken against invoke >= 3. Backport
  # the upstream fix; drop this once nixpkgs merges it, as the patch will then
  # fail to apply. https://github.com/NixOS/nixpkgs/pull/582594
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pyfinal: pyprev: {
          fabric = pyprev.fabric.overridePythonAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              (final.fetchpatch {
                url = "https://github.com/fabric/fabric/commit/7fa309db9dd5dac69079c1fb83b6f579555f7d53.patch";
                hash = "sha256-HxdV1XbsytBYOHV8WqcpKMpqGRkbXD/UlmAFSrmsFTg=";
              })
            ];
            pythonRelaxDeps = [ "invoke" ];
            meta = old.meta // { broken = false; };
          });
        })
      ];
    })
  ];

  environment.systemPackages = with pkgs; [
    tree
    github-cli
    cmake
    gcc
    hidapi
    pkg-config
    jstest-gtk
    openconnect
    git
    peaclock
    unzip
    btop
    cava
    vulkan-tools
    mesa
    vim
    wget
    fd
    tree-sitter
    ripgrep
    pamixer
    feh
    spotify-player
    github-copilot-cli
    opencode
    (azure-cli.withExtensions [
      azure-cli.extensions.bastion
      azure-cli.extensions.ssh
    ])
    claude-code
    android-tools
  ];

  # Enable NetworkManager Applet (provides nm-applet and nm-connection-editor)
  programs.nm-applet.enable = true;

  # Enable the NetworkManager OpenConnect plugin globally
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];
}
