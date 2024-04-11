
# clang=1:14.0-55~exp2
# cmake=3.22.1-1ubuntu1
# cmake-data=3.22.1-1ubuntu1
# lld=1:14.0-55~exp2
# valgrind=1:3.18.1-1ubuntu2

{
  description = "A Nix-flake-based C++ development environment for cs225";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      cmake.url = "github:nixos/nixpkgs/98bb5b77c8c6666824a4c13d23befa1e07210ef1";
      clang.url = "github:nixos/nixpkgs/0343e3415784b2cd9c68924294794f7dbee12ab3";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.x86_64-linux.default =
        pkgs.mkShell {
            nativeBuildInputs = 
            let
              flakepkg = pkg: inputs.${pkg}.legacyPackages.${system}.${pkg};
            in [
                (flakepkg "cmake")
            ];
        };
    };
}





#{
#  description = "Development environment with overlayed clang++";
#
#  inputs = {
#    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#  };
#
#  outputs = { self, nixpkgs }: {
#    devShell = rec {
#      system = "x86_64-linux";
#      packages = [
#        (nixpkgs.legacyPackages.${system}.clang.overrideAttrs (oldAttrs: {
#          version = "13.0.0";
#        }))
#      ];
#    };
#  };
#}

