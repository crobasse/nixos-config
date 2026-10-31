{
  description = "Configuration NixOS modulaire pour cleyh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    asus-numberpad-driver = {
      url = "github:asus-linux-drivers/asus-numberpad-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, asus-numberpad-driver, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
	{
          nixpkgs.overlays = [ asus-numberpad-driver.overlays.default ];
        }
        ./hosts/laptop
        ./modules/core.nix
        ./modules/desktop.nix
        ./modules/dev.nix
        ./modules/virtualization.nix
        ./modules/vpn.nix
        ./modules/zsh.nix
	#asus-numberpad-driver.nixosModules.default
	#./modules/asus-numberpad.nix
      ];
    };
  };
}
