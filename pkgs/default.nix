{pkgs ? import <nixpkgs> {}, ...}: {
  waywall-glfw = pkgs.callPackage ./waywall-glfx.nix {};
  gpu-select = pkgs.callPackage ./gpu-select {};
  repo-find = pkgs.callPackage ./repo-find {};
}
