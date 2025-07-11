{ inputs
, lib
, config
, pkgs
, options
, ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = [ "/etc/nix/path" ];
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.garnix.io"
        "https://prismlauncher.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
      ];
    };
    extraOptions = ''
      trusted-users = root roshan
    '';
  };

  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  networking.hostName = "razer";
  networking.networkmanager.enable = true;

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        timeoutStyle = "hidden";
        extraEntries = ''
          menuentry "Windows" {
              insmod ntfs
              set root=(hd0,gpt1)
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    kernelParams = [ "button.lid_init_state=open" ];
  };


  # hack for when i just want things to be fhs compliant
  programs.nix-ld = {
    enable = true;
    libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
      alsa-lib # electron
      at-spi2-atk # electron
      cairo # electron
      cups # electron
      dbus # electron
      expat # electron
      gdk-pixbuf # electron
      glib # electron
      gtk3 # electron
      gtk4 # electron
      nss # electron
      nspr # electron
      xorg.libX11 # electron
      xorg.libxcb # electron
      xorg.libXcomposite # electron
      xorg.libXdamage # electron
      xorg.libXext # electron
      xorg.libXfixes # electron
      xorg.libXrandr # electron
      xorg.libxkbfile # electron
      xorg.libxshmfence # electron
      pango # electron
      pciutils # electron
      stdenv.cc.cc # electron
      systemd # electron
      libnotify # electron
      pipewire # electron
      libsecret # electron
      libpulseaudio # electron
      speechd-minimal # electron
      libdrm # electron
      mesa # electron
      libxkbcommon # electron
      libGL # electron
      vulkan-loader # electron
    ]);
  };


  # Nvidia stuff

  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware = {
  #   graphics.enable = true;
  #
    # nvidia = {
    #   modesetting.enable = true;
  #     powerManagement.enable = false;
  #     powerManagement.finegrained = false;
      # open = false;
  #     nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
  #     prime = {
  #       offload = {
  #         enable = true;
  #         enableOffloadCmd = true;
  #       };
  #       # sync.enable = true;
  #       nvidiaBusId = "PCI:1:0:0";
  #       amdgpuBusId = "PCI:4:0:0";
  #     };
    # };
  # };

  hardware.keyboard.qmk.enable = true;

  hardware.openrazer = {
    enable = true;
    users = ["roshan"];
  };

  stylix = {
    enable = true;
    # enable = false;

    image = ../../modules/home-manager/hyprland/wallpapers/houses.png;
    #        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

    base16Scheme = {
      base00 = "282828";
      base01 = "3c3836";
      base02 = "504945";
      base03 = "665c54";
      base04 = "bdae93";
      base05 = "d5c4a1";
      base06 = "ebdbb2";
      base07 = "fbf1c7";
      base08 = "fb4934";
      base09 = "fe8019";
      base0A = "fabd2f";
      base0B = "b8bb26";
      base0C = "8ec07c";
      base0D = "83a598";
      base0E = "d3869b";
      base0F = "d65d0e";
    };

    polarity = "dark";
    fonts = rec {
      # monospace = {
      #     package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      #     name = "JetBrainsMono Nerd Font Mono";
      # };

      # monospace = {
      #   package = pkgs.nerdfonts.override {
      #     fonts = ["JetBrainsMono" "Hack" "FiraCode"];
      #   };
      #   name = "Hack Nerd Font Mono";
      # };

      # serif = monospace;
      # sansSerif = monospace;
      # emoji = monospace;

      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };

  # sound stuffs
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  time.timeZone = "America/Chicago";

  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };
  programs.git.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 5";
    flake = "/home/roshan/nixconf";
  };
  programs.command-not-found.enable = false;

  environment.systemPackages =
    (with pkgs; [
      vim
      wget
      neofetch
      unzip
      sl
      obs-studio
      pamixer
      brightnessctl
      polychromatic
      openrazer-daemon
      tree
      devenv
    ])
    ++ [
      inputs.dash.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  security.sudo.wheelNeedsPassword = false;
  virtualisation.docker.enable = true;

  users.users = {
    roshan = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "openrazer"];
      shell = pkgs.fish;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    users = {
      "roshan" = import ./home.nix;
    };
  };

  system.stateVersion = "23.11"; # never change this
}
