{
  inputs,
  outputs,
  ...
}: {
  imports =
    [
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
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };
}
