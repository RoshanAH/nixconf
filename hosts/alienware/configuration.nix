{ inputs
, lib
, config
, pkgs
, ...
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

  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  nix.nixPath = [ "/etc/nix/path" ];
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

  networking = {
    hostName = "alienware";
    networkmanager.enable = true;
    firewall.allowedUDPPortRanges = [
      {
        from = 24454;
        to = 24455;
      }
    ];
  };

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

  environment.systemPackages =
    (with pkgs; [
      vim
      tmux
      wget
      neofetch
      unzip
      sl
    ])
    ++ [
      inputs.dash.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      # fetching packwiz as derivation
      servers.rmcraft =
        let
          modpack = pkgs.fetchPackwizModpack {
            url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/RMCraft/pack.toml";
            packHash = "sha256-qGydjvtKj6lZPHwyRPL+dzKCzLlwyFtUnM0nMMBaQZo=";
          };
          mcVersion = modpack.manifest.versions.minecraft;
          fabricVersion = modpack.manifest.versions.fabric;
          serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";

          collectFilesAt =
            let
              mapListToAttrs = fn: fv: list:
                lib.listToAttrs (map (x: lib.nameValuePair (fn x) (fv x)) list);
            in
            path: prefix:
              mapListToAttrs
                (x: builtins.unsafeDiscardStringContext (lib.removePrefix "${path}/" x))
                (lib.id)
                (lib.filesystem.listFilesRecursive "${path}/${prefix}");
        in
        {
          enable = true;
          serverProperties.server-port = 25566;
          package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
          symlinks = {
            "mods" = "${modpack}/mods";
            "datapacks" = "${modpack}/datapacks";
          };
          files = collectFilesAt modpack "config";
        };

      servers.proxfarmer =
        let
          modpack = pkgs.fetchPackwizModpack {
            url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/ProxFarmers/pack.toml";
            packHash = "sha256-MicLpS3mUUoxaNjjvYg7EniiFJFskBRDbagTG1svZ8w=";
          };
          mcVersion = modpack.manifest.versions.minecraft;
          # fabricVersion = modpack.manifest.versions.fabric;
          serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";

          collectFilesAt =
            let
              mapListToAttrs = fn: fv: list:
                lib.listToAttrs (map (x: lib.nameValuePair (fn x) (fv x)) list);
            in
            path: prefix:
              mapListToAttrs
                (x: builtins.unsafeDiscardStringContext (lib.removePrefix "${path}/" x))
                (lib.id)
                (lib.filesystem.listFilesRecursive "${path}/${prefix}");
        in
        {
          enable = true;
          # package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
        package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = "0.16.1"; };
          symlinks = {
            "mods" = "${modpack}/mods";
            # "datapacks" = "${modpack}/datapacks";
          };
          files = collectFilesAt modpack "config";
        };
      

    };

  security.sudo.wheelNeedsPassword = false;

  users.users = {
    roshan = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
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
