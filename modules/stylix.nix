{ pkgs, ... }:

{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://media.starcitizen.tools/8/84/Hawk_SpaceFlight_Concept.jpg?download";
      hash = "sha256-fMZ53Mr8z7M+9FV9OXCaTFsNNb8fxyUoxPM/deYa69k=";
    };
    base16Scheme = {
      # --- BACKGROUNDS & UI ---
      base00 = "0A1D29"; # Default Background (Deep Blue)
      base01 = "0F2C3E"; # Lighter Background (Status bars, panels)
      base02 = "143A52"; # Selection Background
      base03 = "516673"; # Comments, Invisibles, Line Highlighting

      # --- FOREGROUNDS (TEXT) ---
      base04 = "86A5B8"; # Dark Foreground (Inactive text, muted grey-blue)
      base05 = "C0D5E2"; # Default Foreground (Readable off-white with blue tint)
      base06 = "E1EEF5"; # Light Foreground (Hover states)
      base07 = "F4F8FA"; # Brightest text (Rarely used)

      # --- COLORS / SYNTAX HIGHLIGHTING ---
      base08 = "FF6B8B"; # Red: Variables, XML Tags, Markup Link Text, Diff Deleted
      base09 = "FE9B54"; # Orange: Integers, Boolean, Constants
      base0A = "F3E47C"; # Yellow: Classes, Markup Bold, Search Text Background
      base0B = "A2E57B"; # Green: Strings, Inherited Class, Diff Inserted
      base0C = "73DACA"; # Cyan: Regular Expressions, Escape Characters

      # THE MAIN ACCENT:
      base0D = "54ADF7"; # Blue: Headings, Primary Accent, Functions, Methods

      base0E = "E962E0"; # Magenta/Pink: Keywords, Storage, Selector, Diff Changed
      base0F = "B98EFF"; # Purple: Deprecated, Opening/Closing Tags
    };

    cursor = {
      package = pkgs.apple-cursor;
      name = "Apple Cursor";
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
