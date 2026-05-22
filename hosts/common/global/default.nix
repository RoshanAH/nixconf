{
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index

    ./nix.nix
    ./locale.nix
    ./sops.nix
    ./openssh.nix
    ./fish.nix
    ./zsh.nix
    ./nh.nix
    ./command-not-found.nix
    ./libinput.nix
    ./passwordless-sudo.nix
    ./base-packages.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs; hostName = config.networking.hostName;};
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };
}
