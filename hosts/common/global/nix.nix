{
  inputs,
  lib,
  config,
  ...
}: {
  nix = {
    registry = lib.mapAttrs (_: flake: {inherit flake;}) (
      lib.filterAttrs (_: lib.isType "flake") inputs
    );
    nixPath = ["/etc/nix/path"];
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.garnix.io"
        "https://prismlauncher.cachix.org"
      ];
      trusted-substituters = [
        "https://hyprland.cachix.org"
        "https://cache.garnix.io"
        "https://prismlauncher.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
      ];
    };
    extraOptions = ''
      trusted-users = root roshan
    '';
  };

  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;
}
