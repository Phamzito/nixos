{
  description = "Phamnochita Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager,  ... }@inputs: {
    nixosConfigurations.phamnochita = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.pham = import ./home.nix;
        }
      ];
    };
  };
}
