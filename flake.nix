{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";

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

    ninjabrainbot = {
      url = "github:roshanah/ninjabrainbot-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    razerdaemon = {
      url = "github:encomjp/razer-control-revived";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    riscv-toolchain.url = "github:RoshanAH/riscv-qemu-toolchain";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;

    overlays = import ./overlays {inherit inputs outputs;};

    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachSystem (pkgs: {default = import ./shell.nix {inherit pkgs;};});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      razer = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/razer];
      };
      juno = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/juno];
      };
      alienware = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/alienware];
      };
    };
  };
}
