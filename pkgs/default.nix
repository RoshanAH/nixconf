{ pkgs ? import <nixpkgs> { }, ...} : rec {
    battop = pkgs.callPackage ./battop { };
}
