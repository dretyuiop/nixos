{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Nvidia
      ../../modules/hardware/nvidia

      # Gaming
      ../../modules/gaming/system.nix
    ];

    # Hostname
    networking.hostName = "Dell-G15-5525";
}
