{ pkgs, ... }:

{
  stylix.enable = true;
  stylix.image = ./wallpapers/wall2.png;
  stylix.base16Scheme = {
    base00 = "091b2a"; # Background
    base01 = "3c3836"; # Lighter background
    base02 = "504945"; # Selection background
    base03 = "665c54"; # Comments, Invisibles, Line Highlighting
    base04 = "bdae93"; # Dark Foreground (Used for status bars)
    base05 = "d5c4a1"; # Default Foreground, Caret, Delimiters, Operators
    base06 = "ebdbb2"; # Light Foreground (Not often used)
    base07 = "fbf1c7"; # Light Background (Not often used)
    base08 = "fb4934"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "fe8019"; # Integers, Boolean, Constants, XML Attributes, Markup Link Reference
    base0A = "fabd2f"; # Classes, Markup Bold, Search Text Background
    base0B = "b8bb26"; # Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "8ec07c"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "83a598"; # Functions, Methods, Attribute IDs, Headings
    base0E = "d3869b"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "d65d0e"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  };

  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";
  stylix.cursor.size = 24;

  stylix.fonts = {
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
}
