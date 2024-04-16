{ pkgs, ... }:
{
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
        "remove-gtkrc-2.0" = {
          text = "rm -f $VERBOSE_ARG rm -f $HOME/.gtkrc-2.0";
        };
        "set-temp-limit" = {
          text = "sudo ryzenadj -f 88";
        };
      };
    };

  };
}
