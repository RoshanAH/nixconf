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
            "https://cache.garnix.io"
        ];
        trusted-public-keys = [
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
    };

    networking.hostName = "alienware";
    networking.networkmanager.enable = true;

    services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        extraConfig = ''
            PubkeyAuthentication yes
        '';
    };

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.enable = true;

    time.timeZone = "America/Chicago";

    programs.fish = {
        enable = true;
        vendor = {
            completions.enable = true;
            config.enable = true;
            functions.enable = true;
        };
    };
    programs.git.enable = true;

    programs.command-not-found.enable = false;

    environment.systemPackages = (with pkgs; [
        vim
        wget
        neofetch
        unzip
        sl
    ]) ++ [
        inputs.dash.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]; 

    security.sudo.wheelNeedsPassword = false;

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
