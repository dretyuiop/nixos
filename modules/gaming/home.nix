{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # game
    steam-run
    lutris-free
    mangohud
    heroic
    wineWowPackages.waylandFull
    winetricks
    bottles
  ];

  programs = {
    mangohud = {
      enable = true;
      enableSessionWide = true;
      settings =  {
        no_display = 1;
        toggle_hud = "F11";
        gpu_text = "GPU";
        gpu_load_change = 1;
        gpu_load_value = "50,90";
        throttling_status = 1;
        gpu_core_clock = 1;
        gpu_temp = 1;
        gpu_power = 1;
        cpu_text = "CPU";
        cpu_load_change = 1;
        cpu_load_value = "50,90";
        cpu_mhz = 1;
        cpu_temp = 1;
        ram = 1;
        fps = 1;
        vulkan_driver = 1;
        wine = 1;
        output_folder = "$HOME/.local/share/mangohud";
        log_duration = 30;
        autostart_log = 0;
        log_interval = 100;
        toggle_logging = "Shift_L+F2";
      };
    };
  };
}
