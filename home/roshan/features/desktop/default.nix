{pkgs, ...}: {
  imports = [
    ./hyprland
    ./jay
    ./kitty.nix
    ./firefox.nix
    ./zathura.nix
    ./spotify-player.nix
    ./stylix.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    discord
    ffmpeg
    python3
    musescore
  ];
}
