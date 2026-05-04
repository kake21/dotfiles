{ pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://media.starcitizen.tools/8/84/Hawk_SpaceFlight_Concept.jpg?download";
      hash = "sha256-fMZ53Mr8z7M+9FV9OXCaTFsNNb8fxyUoxPM/deYa69k=";
    };
    base16Scheme = {
      base00 = "0A1D29"; # Background
      base01 = "0F2C3E"; # Lighter background
      base02 = "143A52"; # Selection background
      base03 = "516673"; # Comments, Invisibles, Line Highlighting
      base04 = "06151F"; # Dark Foreground (Used for status bars)
      base05 = "54adf7"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "ebdbb2"; # Light Foreground (Not often used)
      base07 = "fbf1c7"; # Light Background (Not often used)
      base08 = "fb4934"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "fe8019"; # Integers, Boolean, Constants, XML Attributes, Markup Link Reference
      base0A = "54adf7"; # Classes, Markup Bold, Search Text Background
      base0B = "e9c600"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "8ec07c"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "b1b1b3"; # Functions, Methods, Attribute IDs, Headings
      base0E = "fd7de7"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "b98eff"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
    };
  };
}
