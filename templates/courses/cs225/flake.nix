{
  description = "Development environment with overlayed clang++";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    devShell = {
      system = "x86_64-linux";
      packages = [
        (nixpkgs.legacyPackages.${system}.clang.overrideAttrs (oldAttrs: {
          version = "13.0.0";
        }))
      ];
    };
  };
}

