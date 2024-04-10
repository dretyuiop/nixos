{ pkgs, ... }:
{
  imports = [  <plasma-manager/modules> ];

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      iconTheme = "Tela-dracula-dark";
      theme = "Dracula";
    };

    spectacle.shortcuts = {
      captureRectangularRegion = "Print";
    };

    startup = {
      autoStartScript = {
        "remove-gtk2" = {
          text = "rm -f $HOME/.gtkrc-2.0";
        };
        "set-temp-limit" = {
          text = "sudo ryzenadj -f 88";
        };
      };
    };
  };
}
