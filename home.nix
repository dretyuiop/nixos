#Dell G15
{ config, pkgs, lib, ... }:

{
#   imports = [  ./plasma/plasma.nix  ];

  home.username = "cch";
  home.homeDirectory = "/home/cch";
  home.packages = with pkgs; [
    # basic utils
    psmisc
    lm_sensors
    wget
    lshw
    iputils
    bind
    glxinfo
    vulkan-tools

    # standard
    libva-utils
    chezmoi
    gnupg
    fzf
    ripgrep
    ripgrep-all
    eza
    bat

    # themes
    kdePackages.qtstyleplugin-kvantum
    (callPackage ./pkgs/kvantum.nix { })
    (callPackage ./pkgs/twilight-kde.nix { })
    dracula-theme
    tela-icon-theme

    # code

    # apps
    yakuake
    ferdium
    fsearch
    trayscale
    htop
    powerstat
    ocs-url
    librewolf
    nextcloud-client
    libreoffice-qt
    mission-center
    haruna
    yt-dlp
    nur.repos.xddxdd.wine-wechat

    # game
    lutris
    mangohud
    heroic
    wineWowPackages.waylandFull
    winetricks
    bottles

    # scripts
    (pkgs.writeShellScriptBin "cputemp" ''
      if [ $(cat "/sys/class/power_supply/BAT1/status") != "Discharging" ]; then
        sensors | grep -A 0 'Tctl' | cut -c16-17
      fi
    '')
    (pkgs.writeShellScriptBin "gputemp" ''
    if [ $(cat "/sys/class/power_supply/BAT1/status") != "Discharging" ] && [ -z "$(nvidia-smi | grep failed)" ]; then
      nvidia-smi --query-gpu temperature.gpu --format=csv,noheader
    fi
    '')
  ];

  home.file = {
    "kvantum" = {
      text = ''
        [General]
        theme=LavandaSeaDark#
      '';
      target = ".config/Kvantum/kvantum.kvconfig";
    };
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
    LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
    fish_greeting = "";
  };

  programs = {
    bash.enable = true;

    aria2 = {
      enable = true;
      settings = {
        dir = "/home/cch/Downloads" ;
        enable-mmap = true ;
        disk-cache = "64M" ;
        file-allocation = "falloc" ;
        continue = true ;
        split = 16 ;
        max-connection-per-server = 16 ;
        optimize-concurrent-downloads = true ;
        input-file = "/home/cch/.local/aria2/aria2.session" ;
        save-session = "/home/cch/.local/aria2/aria2.session" ;
        save-session-interval = 60 ;
        user-agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" ;
        enable-rpc = true ;
        rpc-listen-port = 6800 ;
        rpc-secret = "aria2" ;
        follow-torrent = false ;
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ rustup zlib ]);
    };

    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-wayland-ime"
      ];
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };

    fish = {
      enable = true;
      plugins = [
        { name = "done"; src = pkgs.fishPlugins.done.src; }
        { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
        { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
        { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
      shellAliases = {
        cat = "bat";
        cp = "cp -v";
        hm = "rm -f /home/cch/.config/gtk-2.0/gtkrc && home-manager --impure";
        hms = "rm -f /home/cch/.config/gtk-2.0/gtkrc && home-manager switch --impure";
        la = "eza --long --header --all --icons";
        ls = "eza --long --header --icons";
        mkdir = "mkdir -v";
        mv = "mv -v";
        rm = "rm -v";
        sys = "sudo systemctl";
        sysu = "systemctl --user";
        tree = "eza --tree --level=2";
      };
    };

    git = {
      enable = true;
      userEmail = "chewch03@gmail.com";
      userName = "dretyuiop";
    };

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

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        package.disabled = true;
        command_timeout = 1000;
        format = lib.concatStrings [
          "[╭╴](238)$shell"
          "$all"
          "$line_break"
          "[╰─](238)$character"
        ];
        shell = {
          fish_indicator = "󰈺";
          bash_indicator = "";
          disabled = false;
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        username = {
          style_user = "fg:#ff79c6";
          style_root = "red";
          format = "[▮](blue)[$user]($style)";
          show_always = false;
        };
        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
          home_symbol = "󰋜 ~";
          read_only_style = "197";
          read_only = "  ";
          format = "at [$path]($style)[$read_only]($read_only_style) ";
        };
        git_branch = {
          symbol = "󰊢 ";
          style = "bold green";
          format = "on [$symbol$branch]($style) ";
        };
        c.symbol = " ";
        conda.symbol = " ";
        dart.symbol = " ";
        docker_context.symbol = " ";
        fossil_branch.symbol = " ";
        golang.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        lua.symbol = " ";
        nodejs.symbol = " ";
        python.symbol = " ";
        ruby.symbol = " ";
        rust.symbol = " ";
      };
    };
  };

  services = {
    home-manager.autoUpgrade = {
      enable = true;
      frequency = "daily";
    };
  };

  systemd.user.services = {
    "aria2" = {
      Unit = {
        After = "network.target";
      };
      Service = {
        ExecStart = "${pkgs.aria2}/bin/aria2c";
        ExecStartPre = "${pkgs.coreutils}/bin/touch /home/cch/.local/aria2/aria2.session";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.callPackage ./pkgs/lavanda.nix { };
      name = "Lavanda-Sea-Dark";
    };
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
#       platformTheme = "kde";
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    allowUnfree = true;
    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };

  # The state version is required and should stay at the version you
  # originally installed.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
