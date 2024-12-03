{
    inputs,
        lib,
        config,
        pkgs,
        ...
}: {
    imports = [
        ./hardware-configuration.nix
        inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

    nixpkgs = {
        overlays = [
          inputs.nix-minecraft.overlay
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
        tmux
        wget
        neofetch
        unzip
        sl
    ]) ++ [
        inputs.dash.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]; 

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.rmcraft = let
        modpack = pkgs.fetchPackwizModpack {
          url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/RMCraft/pack.toml";
          packHash = "sha256-d+a5gPEafisb645esXDRowq5MRQgCUeeHkL37sSG00s=";
        };
        mcVersion = modpack.manifest.versions.minecraft;
        fabricVersion = modpack.manifest.versions.fabric;
        serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
    in {
        enable = true;
        package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
        symlinks = {
          "mods" = "${modpack}/mods";
      };
    };
  };
    

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
