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

    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
            prime = {
                offload = {
                    enable = true;
                    enableOffloadCmd = true;
                };
                amdgpuBusId = "PCI:4:0:0";
                nvidiaBusId = "PCI:1:0:0";
            };

        };
    };

# well this is sadly all useless now since i can just do this through hyprland 
#    services.acpid = {
#        enable = true;
#        handlers = {
#            lid-open = {
#                event = "button/lid LID open.*";
#                action = let 
#                    enableMonitor = pkgs.writeShellApplication {
#                        name = "enable-monitor";
#                        runtimeInputs = [ pkgs.hyprland pkgs.alacritty ];
#                        text = ''
#                            hyprctl keyword monitor eDP-1,1920x1080@144,0x0,1 
#                            '';
#                    };
#                in "${enableMonitor}/bin/enable-monitor";
#            };
#        };
#    };

    stylix.image = ../../home/roshan/wallpapers/houses.png;
    stylix.polarity = "dark";

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
    programs.git.enable = true;
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };



    environment.systemPackages = with pkgs; let 
        primeOffload = pkgs.writeShellScriptBin "prime-offload" ''
            export __NV_PRIME_RENDER_OFFLOAD=1
            export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
            export __GLX_VENDOR_LIBRARY_NAME=nvidia
            export __VK_LAYER_NV_optimus=NVIDIA_only
            exec "$@"
        '';
    in [
            vim
            wget
            neofetch
            unzip
            sl
            lshw
            obs-studio
            primeOffload
#    audio
            pamixer
#    brightness
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
            shell = pkgs.zsh;
        };
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            "roshan" = import ../../home/roshan/home.nix;
        };
    };

    system.stateVersion = "23.11"; # never change this
}
