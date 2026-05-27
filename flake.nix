{
  description = "Vex NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-citizen.url = "github:LovingMelody/nix-citizen";

    nixcord.url = "github:FlameFlag/nixcord";

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, stylix, hy3, nixvim, ... }@inputs:
  let
    system = "x86_64-linux";
    mkHost = hostName: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        stylix.nixosModules.stylix
        ./hosts/${hostName}/configuration.nix

        home-manager.nixosModules.home-manager
        hyprland.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.users.vegard = import ./home-manager/home.nix;

          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  in
  {
    nixosConfigurations = {
      vex = mkHost "vex";
      laptop = mkHost "laptop";
      iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/iso/configuration.nix
        ];
      };
    };
  };
}
