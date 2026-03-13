{
  description = "Vex NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal.url = "github:aylur/astal";
    ags.url = "github:aylur/ags";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.vex = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
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
