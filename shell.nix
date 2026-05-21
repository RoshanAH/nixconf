{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = with pkgs; [
    nh
    nixos-rebuild
    sops
    age
    ssh-to-age
    alejandra
  ];
}
