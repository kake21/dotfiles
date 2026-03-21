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

    nix-citizen.url = "github:LovingMelody/nix-citizen";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.vex = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        stylix.nixosModules.stylix
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.users.vegard = import ./home-manager/home.nix;

          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
