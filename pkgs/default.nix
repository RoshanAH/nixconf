{ pkgs ? import <nixpkgs> { }, ...} : rec {
  waywall-glfw = pkgs.callPackage ./waywall-glfx.nix {};
}
