{ config, ... }:
{
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
}
