{
  description = "Home Manager configuration of isabella";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, home-manager, ... }:
      flake-parts.lib.mkFlake { inherit inputs; } {
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
        imports = [
          inputs.home-manager.flakeModules.home-manager
        ];
        flake = {
          homeConfigurations."isabella" = home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            modules = [ ./home.nix ];
          };
        };
      };
}
