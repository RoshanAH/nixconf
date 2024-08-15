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

    dash = {
        url = "github:roshanah/dash";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox = {
        url = "github:nix-community/flake-firefox-nightly";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    flakeRoot = ./.;
  in {

    packages.x86_64-linux = import ./pkgs { pkgs = nixpkgs.legacyPackages.x86_64-linux; };

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      razer = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs flakeRoot;};
        modules = [
            ./hosts/razer/configuration.nix
            inputs.nix-index-database.nixosModules.nix-index
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
        ];
      };
    };
  };
}
