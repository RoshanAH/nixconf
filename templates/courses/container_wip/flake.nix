# Do not modify! This file is generated.

{
  description = "A Nix-flake-based C++ development environment for cs225";
  inputs = {
    clangNixPkgs.url = "github:nixos/nixpkgs/0343e3415784b2cd9c68924294794f7dbee12ab3";
    cmakeNixPkgs.url = "github:nixos/nixpkgs/98bb5b77c8c6666824a4c13d23befa1e07210ef1";
    flakegen.url = "github:jorsn/flakegen";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = inputs: inputs.flakegen ./flake.in.nix inputs;
}