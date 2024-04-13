{
  description = "System configuration for cch";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    nur.url = github:nix-community/NUR;
  };


  outputs = inputs@{ self, nixpkgs, utils, home-manager, nur }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      sharedOverlays = [
        nur.overlay
      ];

      hostDefaults.modules = [
        ../hosts/common/system.nix
        /etc/nixos/hardware-configuration.nix
      ];

      hosts = {
        Dell-G15-5525.modules = [ ../hosts/Dell-G15-5525/system.nix ];
        Modern-14.modules = [ ../hosts/Modern-14/system.nix ];
      };

    };
}

