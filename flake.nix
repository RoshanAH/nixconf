{
  description = "My NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
        url = "github:hyprwm/contrib";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    prismlauncher.url = "github:PrismLauncher/PrismLauncher";

    nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    flakeRoot = ./.;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      razer = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs flakeRoot;};
        modules = [
            ./machines/razer/configuration.nix
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      "roshan@razer" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs flakeRoot;};
        # > Our main home-manager configuration file <
        modules = [ 
            inputs.stylix.homeManagerModules.stylix
            inputs.nix-index-database.hmModules.nix-index
            ./machines/razer/home.nix
        ];
      };
    };
  };
}
