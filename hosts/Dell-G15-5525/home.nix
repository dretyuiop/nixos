{ config, pkgs, lib, ... }:

{
  imports =
    [
      # KDE Plasma
      ../../modules/plasma/home.nix

      # Gaming
      ../../modules/gaming/home.nix
    ];
}
