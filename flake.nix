{
  description = "Home Manager configuration of cch";

  inputs = {
    stable.url = github:nixos/nixpkgs/nixos-23.11;
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = github:pjones/plasma-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nur.url = github:nix-community/NUR;
  };

  outputs = inputs@ { stable, nixpkgs, home-manager, plasma-manager, nur,  ... }:
    let
      mkHome = hostModule: home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [
              nur.overlay
              (import ./overlay/pkgs.nix)
              (final: prev: {stable = stable.legacyPackages.${prev.system};})
            ];
            config.allowUnfree = true;
          };
          modules = [
            ./hosts/common/home.nix
            ./modules
            plasma-manager.homeManagerModules.plasma-manager
            hostModule
          ];
      };
    in {
      homeConfigurations = {
        "cch@Dell-G15-5525" = mkHome ./hosts/Dell-G15-5525/home.nix;
        "cch@Modern-14" = mkHome ./hosts/Modern-14/home.nix;
      };
    };
}
