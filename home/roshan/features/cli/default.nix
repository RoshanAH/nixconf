{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./tmux.nix
    ./nvim
    ./repo-find.nix
  ];

  home.packages = with pkgs; [
    fzf
    ripgrep
    fd
    btop
  ];
}
