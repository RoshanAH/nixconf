{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/openssh.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.mm-api.nixosModules.default
  ];

  nixpkgs = {
    overlays = [
      inputs.nix-minecraft.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
    (lib.filterAttrs (_: lib.isType "flake")) inputs
  );

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
      # TODO move this to a module
      # {
      #   from = 24454;
      #   to = 24455;
      # }
    ];
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


  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/roshan/nixconf";
  };


  programs.git.enable = true;
  programs.command-not-found.enable = false;

  environment.systemPackages =
    (with pkgs; [
      vim
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
    # servers.rmcraft =
    #   let
    #     modpack = pkgs.fetchPackwizModpack {
    #       url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/RMCraft/pack.toml";
    #       packHash = "sha256-qGydjvtKj6lZPHwyRPL+dzKCzLlwyFtUnM0nMMBaQZo=";
    #     };
    #     mcVersion = modpack.manifest.versions.minecraft;
    #     fabricVersion = modpack.manifest.versions.fabric;
    #     serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
    #
    #     collectFilesAt =
    #       let
    #         mapListToAttrs = fn: fv: list:
    #           lib.listToAttrs (map (x: lib.nameValuePair (fn x) (fv x)) list);
    #       in
    #       path: prefix:
    #         mapListToAttrs (x: builtins.unsafeDiscardStringContext (lib.removePrefix "${path}/" x)) (lib.id) (
    #           lib.filesystem.listFilesRecursive "${path}/${prefix}"
    #         );
    #   in
    #   {
    #     enable = true;
    #     serverProperties.server-port = 25566;
    #     package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
    #     symlinks = {
    #       "mods" = "${modpack}/mods";
    #       "datapacks" = "${modpack}/datapacks";
    #     };
    #     files = collectFilesAt modpack "config";
    #   };

    # servers.real-vanilla =
    #   let
    #     modpack = pkgs.fetchPackwizModpack {
    #       url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/vanilla/pack.toml";
    #       packHash = "sha256-w20kRvZRH54hjfXpt22XFrj7COceJiD1m9qJqLwN9ao=";
    #     };
    #     mcVersion = modpack.manifest.versions.minecraft;
    #     fabricVersion = modpack.manifest.versions.fabric;
    #     serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
    #   in
    #   {
    #     enable = true;
    #     serverProperties.server-port = 25566;
    #     package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
    #     symlinks = {
    #       "mods" = "${modpack}/mods";
    #     };
    #   };

    # servers.proxfarmer =
    #   let
    #     modpack = pkgs.fetchPackwizModpack {
    #       url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/ProxFarmers/pack.toml";
    #       packHash = "sha256-MicLpS3mUUoxaNjjvYg7EniiFJFskBRDbagTG1svZ8w=";
    #     };
    #     mcVersion = modpack.manifest.versions.minecraft;
    #     # fabricVersion = modpack.manifest.versions.fabric;
    #     serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
    #
    #     collectFilesAt =
    #       let
    #         mapListToAttrs = fn: fv: list:
    #           lib.listToAttrs (map (x: lib.nameValuePair (fn x) (fv x)) list);
    #       in
    #       path: prefix:
    #         mapListToAttrs
    #           (x: builtins.unsafeDiscardStringContext (lib.removePrefix "${path}/" x))
    #           (lib.id)
    #           (lib.filesystem.listFilesRecursive "${path}/${prefix}");
    #   in
    #   {
    #     enable = true;
    #     # package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
    #     package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = "0.16.1"; };
    #     symlinks = {
    #       "mods" = "${modpack}/mods";
    #       # "datapacks" = "${modpack}/datapacks";
    #     };
    #     files = collectFilesAt modpack "config";
    #   };

    # servers.smoll =
    #   let
    #     modpack = pkgs.fetchPackwizModpack {
    #       url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/smoll/pack.toml";
    #       packHash = "sha256-70PJecKdRY4xI8Ds0qR7Gn5GlZMARyG36YwcF13vRrU=";
    #     };
    #     mcVersion = modpack.manifest.versions.minecraft;
    #     serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
    #
    #     collectFilesAt =
    #       let
    #         mapListToAttrs = fn: fv: list:
    #           lib.listToAttrs (map (x: lib.nameValuePair (fn x) (fv x)) list);
    #       in
    #       path: prefix:
    #         mapListToAttrs (x: builtins.unsafeDiscardStringContext (lib.removePrefix "${path}/" x)) (lib.id) (
    #           lib.filesystem.listFilesRecursive "${path}/${prefix}"
    #         );
    #   in
    #   {
    #     enable = true;
    #     package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = "0.16.14"; };
    #     symlinks = {
    #       "mods" = "${modpack}/mods";
    #     };
    #     files = collectFilesAt modpack "config";
    #   };
    # servers.vanilla =
    #   let
    #     modpack = pkgs.fetchPackwizModpack {
    #       url = "https://raw.githubusercontent.com/RoshanAH/mc-packs/refs/heads/main/hotdog/pack.toml";
    #       packHash = "sha256-gYG8aJATHPNn3lYx5+9x9CnEqnX+INT1sR28blLn4o0=";
    #     };
    #     mcVersion = modpack.manifest.versions.minecraft;
    #     serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
    #
    #     collectFilesAt =
    #       let
    #         mapListToAttrs = fn: fv: list:
    #           lib.listToAttrs (map (x: lib.nameValuePair (fn x) (fv x)) list);
    #       in
    #       path: prefix:
    #         mapListToAttrs (x: builtins.unsafeDiscardStringContext (lib.removePrefix "${path}/" x)) (lib.id) (
    #           lib.filesystem.listFilesRecursive "${path}/${prefix}"
    #         );
    #   in
    #   {
    #     enable = true;
    #     jvmOpts = [ "-Xms2048M" "-Xmx8192M" ];
    #     package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = "0.18.1"; };
    #     symlinks = {
    #       "mods" = "${modpack}/mods";
    #       "datapacks" = "${modpack}/datapacks";
    #     };
    #     files = collectFilesAt modpack "config";
    #   };
  };

  security.sudo.wheelNeedsPassword = false;

  users.users = {
    roshan = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
      shell = pkgs.fish;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    users = {
      "roshan" = import ./roshan.nix;
      "guest" = import ./guest.nix;
    };
  };

  system.stateVersion = "23.11"; # never change this
}
