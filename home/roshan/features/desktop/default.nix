{pkgs, ...}: {
  imports = [
    ./hyprland
    ./kitty.nix
    ./firefox.nix
    ./zathura.nix
    ./spotify-player.nix
    ./stylix.nix
    ./xdg.nix
    ./hyprland-autolaunch.nix
  ];

  home.packages = with pkgs; [
    discord
    ffmpeg
    python3
    prismlauncher
    musescore
  ];
}
