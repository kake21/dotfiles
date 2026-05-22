{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
        };
      };
    };
  };
}
