# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.

    ];

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

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "cch";
    };
  };

  services.xserver = {
    enable = true;
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
  };

  # Nix config
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
#       corefonts
#       vistafonts
      nur.repos.rewine.ttf-ms-win10
    ];
  };

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    sudo = {
      extraRules = [
        { groups = [ "wheel" ];  commands = [ { command = "/home/cch/.nix-profile/bin/ryzenadj"; options = [ "SETENV" "NOPASSWD" ]; } ]; }
      ];
    };
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

  systemd.services.libvirtd.wantedBy = lib.mkForce [];

  virtualisation.libvirtd.enable = true;

  programs = {

    kdeconnect.enable = true;

    virt-manager.enable = true;

    dconf.enable = true;

    chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = true;
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

  system.stateVersion = "23.11"; # Did you read the comment?

}
