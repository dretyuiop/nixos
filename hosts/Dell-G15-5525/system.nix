{ config, lib, pkgs, ... }:

{
  imports =
    [
    # Gaming
    ../../modules/gaming/system.nix

    # Nvidia
    ../../modules/hardware/nvidia
    ];

    # Hostname
    networking.hostName = "Dell-G15-5525";
}
