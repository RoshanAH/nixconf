# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
    inputs,
        lib,
        config,
        pkgs,
        ...
}: {
# You can import other NixOS modules here
    imports = [
# Import your generated (nixos-generate-config) hardware configuration
        ./hardware-configuration.nix
    ];

    nixpkgs = {
# You can add overlays here
        overlays = [
# If you want to use overlays exported from other flakes:
# neovim-nightly-overlay.overlays.default

# Or define it inline, for example:
# (final: prev: {
#   hi = final.hello.overrideAttrs (oldAttrs: {
#     patches = [ ./change-hello-to-hi.patch ];
#   });
# })
        ];
# Configure your nixpkgs instance
        config = {
# Disable if you don't want unfree packages
            allowUnfree = true;
        };
    };

# This will add each flake input as a registry
# To make nix3 commands consistent with your flake
    nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

# This will additionally add your inputs to the system's legacy channels
# Making legacy nix commands consistent as well, awesome!
    nix.nixPath = ["/etc/nix/path"];
    environment.etc =
        lib.mapAttrs'
        (name: value: {
         name = "nix/path/${name}";
         value.source = value.flake;
         })
    config.nix.registry;

    nix.settings = {
# Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
# Deduplicate and optimize nix store
        auto-optimise-store = true;
    };

    networking.hostName = "razer";
    networking.networkmanager.enable = true;

    boot.loader.grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        timeoutStyle = "hidden";
    };
    boot.loader.efi.canTouchEfiVariables = true;

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
        home-manager
            vim
            wget
            neofetch
            sl
#    audio
            pamixer
#    brightness
            brightnessctl
            gnumake
    ]; 

    fonts.packages = with pkgs; [
        jetbrains-mono
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

    system.stateVersion = "23.11"; # never change this
}
