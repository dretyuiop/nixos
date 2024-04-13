{
  description = "Home Manager configuration of cch";

  nixConfig = {
    extra-substituters = [
      "https://xddxdd.cachix.org"
    ];
    extra-trusted-public-keys = [
      "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = github:pjones/plasma-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nur.url = "nur";
  };

  outputs = inputs@ { nixpkgs, home-manager, nur, plasma-manager, ... }:
    let
      mkHome = hostModule: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ nur.overlay ];
          config.allowUnfree = true;
        };
        modules = [
          ./hosts/common/home.nix
          plasma-manager.homeManagerModules.plasma-manager
          hostModule
        ];
      };
    in {
      homeConfigurations = {
        "cch@Dell-G15-5525" = mkHome ./hosts/Dell-G15-5525/home.nix;
      };
    };
}
