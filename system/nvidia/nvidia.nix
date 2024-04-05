{ config, pkgs, ... }:

{
  # Nvidia
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;
      dynamicBoost.enable = true;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd =  true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:52:0:0";
      };
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
}
