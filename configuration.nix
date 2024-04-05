# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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

  # Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Bootloader.
  boot = {
    kernelParams = [ "quiet" ];
    initrd = {
      systemd.enable = true;
    };
    consoleLogLevel = 0;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    plymouth = {
      enable = true;
      themePackages = [ pkgs.adi1090x-plymouth-themes ];
      theme = "rings";
    };
  };

  # Network
  networking = {
    hostName = "Dell-G15-5525";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_SG.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_SG.UTF-8";
      LC_IDENTIFICATION = "en_SG.UTF-8";
      LC_MEASUREMENT = "en_SG.UTF-8";
      LC_MONETARY = "en_SG.UTF-8";
      LC_NAME = "en_SG.UTF-8";
      LC_NUMERIC = "en_SG.UTF-8";
      LC_PAPER = "en_SG.UTF-8";
      LC_TELEPHONE = "en_SG.UTF-8";
      LC_TIME = "en_SG.UTF-8";
    };
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        plasma6Support = true;
        addons = with pkgs; [
          fcitx5-gtk
          kdePackages.fcitx5-with-addons
          kdePackages.fcitx5-chinese-addons
        ];
      };
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "cch";
      };
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Sound
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
#     extraConfig.pipewire = {
#       "fix-crackling" = {
#         "context.properties" = {
#           session.suspend-timeout-seconds = 0;
#           default.clock.allowed-rates = [ 44100 48000 ];
#         };
#       };
#     };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cch = {
    isNormalUser = true;
    description = "cch";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Nix config
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "cch" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    operation = "boot";
    dates = "02:00";
  };

  # System config
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      kdePackages.ktexteditor
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      noto-fonts-cjk
      corefonts
      vistafonts
    ];
  };

  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
  };

  zramSwap.enable = true;

  # Services and programs
  services = {
    printing.enable = true;

    tailscale = {
      enable = true;
#       extraUpFlags = [
#         "--operator=$USER"
#         "--login-server https://headscale.chewfamily.party"
#       ];
    };
  };

  programs = {
    kdeconnect.enable = true;

    dconf.enable = true;

    chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = true;
    };

    gamemode = {
      enable = true;
      enableRenice = true;
    };

    nix-ld = {
      package = pkgs.nix-ld-rs;
      enable = true;
      libraries = with pkgs; [
        acl
        attr
        bzip2
        curl
        kdePackages.full
        libsodium
        libssh
        libxml2
        openssl
        sqlite
        stdenv.cc.cc
        systemd
        util-linux
        xz
        zlib
        zstd
      ];
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
