{ pkgs, ... }:
{
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
}
