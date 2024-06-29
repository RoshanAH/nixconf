let
    versionedPkgs = [
        { name = "cmake"; value = "98bb5b77c8c6666824a4c13d23befa1e07210ef1"; } 
        { name = "clang"; value = "0343e3415784b2cd9c68924294794f7dbee12ab3"; }
        { name = "valgrind"; value = "f2db28ca7cca3f0e8ff74b65c5326f0dc0483288"; }
    ];
    inputName = name: name + "NixPkgs";
    urls = builtins.listToAttrs (map ({ name, value }: { name = (inputName name); value = { url = "github:nixos/nixpkgs/${value}"; }; }) versionedPkgs);
in
{
  description = "A Nix-flake-based C++ development environment for cs225";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  } // urls;

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default =
        pkgs.mkShell {
            nativeBuildInputs = map 
                ({ name, ... } : (inputName name).legacyPackages.${system}.${name})
                versionedPkgs;
        };
    };
}

# valgrind=1:3.18.1-1ubuntu2
