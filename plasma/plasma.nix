{ config, pkgs, lib, ... }:
{
  imports = [  <plasma-manager/modules> ];

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      iconTheme = "Tela-dracula-dark";
      theme = "Twilight-dark";
    };

    hotkeys.commands = {
      "fsearch" = {
        name = "Launch Fsearch";
        key = "Meta+F";
        command = "fsearch";
      };
      "missioncenter" = {
        name = "Launch Mission-Center";
        key = "Ctrl+Shift+Esc";
        command = "missioncenter";
      };
      "brave" = {
        name = "Launch Brave";
        key = "Meta+B";
        command = "brave";
      };
    };

    spectacle.shortcuts = {
      captureRectangularRegion = "Print";
    };
  };
}
