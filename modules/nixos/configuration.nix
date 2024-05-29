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


    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
    hardware.nvidia = {
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

    environment.systemPackages = with pkgs; [
            vim
            wget
            neofetch
            unzip
            sl
            lshw
            obs-studio
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
