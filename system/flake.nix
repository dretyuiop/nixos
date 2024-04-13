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
      ];

      hosts = {
        Dell-G15-5525.modules = [
          ../hosts/Dell-G15-5525/system.nix
          ../hosts/Dell-G15-5525/hardware-configuration.nix
        ];

        Modern-14.modules = [
          ../hosts/Modern-14/system.nix
          ../hosts/Modern-14/hardware-configuration.nix
        ];
      };

    };
}

