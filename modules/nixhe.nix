{
  imports = [ ../CLionProjects/NixHE/nixos-module.nix ];
  programs.nixhe = {
    enable = true;
    axes = [
      {
        name = "Forward/Backwards";
        negativeKeys = [ "A" ];
        positiveKeys = [ "D" ];
      }
      {
        name = "Left/Right";
        negativeKeys = [ "W" ];
        positiveKeys = [ "S" ];
      }
      {
        name = "Roll";
        negativeKeys = [ "Q" ];
        positiveKeys = [ "E" ];
      }
      {
        name = "Roll";
        negativeKeys = [ "Q" ];
        positiveKeys = [ "E" ];
      }
    ];
  };
}