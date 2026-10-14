{
  description = "Configuration NixOS modulaire pour cleyh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/laptop
        ./modules/core.nix
        ./modules/desktop.nix
        ./modules/dev.nix
        ./modules/virtualization.nix
        ./modules/vpn.nix
      ];
    };
  };
}
