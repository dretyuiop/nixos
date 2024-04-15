{ config, pkgs, lib, ... }:

{
  imports =
    [
        # unity hub for game development
        ./unity/home.nix
    ];
}

