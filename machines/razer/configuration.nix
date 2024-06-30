{
    inputs,
        lib,
        config,
        pkgs,
        ...
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

    nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

    nix.nixPath = ["/etc/nix/path"];
    environment.etc =
        lib.mapAttrs'
        (name: value: {
         name = "nix/path/${name}";
         value.source = value.flake;
         })
    config.nix.registry;

    nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;

        substituters = [
            "https://hyprland.cachix.org"
            "https://cache.garnix.io"
        ];
        trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
    };

    networking.hostName = "razer";
    networking.networkmanager.enable = true;

    boot.loader.grub = {
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
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.kernelParams = [ "button.lid_init_state=open" ];

#    services.xserver.videoDrivers = ["nvidia"];
#
#    hardware = {
#        opengl = {
#            enable = true;
#            driSupport = true;
#            driSupport32Bit = true;
#        };
#        nvidia = {
#            modesetting.enable = true;
#            powerManagement.enable = false;
#            powerManagement.finegrained = false;
#            open = true;
#            nvidiaSettings = true;
#            package = config.boot.kernelPackages.nvidiaPackages.stable;
#            prime = {
#                offload = {
#                    enable = true;
#                    enableOffloadCmd = true;
#                };
#                nvidiaBusId = "PCI:1:0:0";
#                amdgpuBusId = "PCI:4:0:0";
#            };
#        };
#    };

    stylix = {
        enable = true;
        

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
            monospace = {
                package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
                name = "JetBrainsMono Nerd Font Mono";
            };

            serif = monospace;
            sansSerif = monospace;
            emoji = monospace;
        };

    };

# sound stuffs
    security.rtkit.enable = true;
    sound.enable = true;
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
    };
    programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--kep-since 4d --keep 3";
        flake  = "/home/user/roshan/nixconf";
    };
    programs.command-not-found.enable = false;

    environment.systemPackages = with pkgs; [
            vim
            wget
            neofetch
            unzip
            sl
            obs-studio
            pamixer
            brightnessctl
    ]; 

    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    fonts.packages = with pkgs; [
        nerdfonts
    ];

    security.sudo.wheelNeedsPassword = false;
    virtualisation.docker.enable = true;

    users.users = {
        roshan = {
            isNormalUser = true;
            extraGroups = ["wheel" "networkmanager" "docker"];
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
