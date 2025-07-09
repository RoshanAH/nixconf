# This is your home-manager configuration filehome
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ../../modules/home-manager/nvim
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/tmux.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    fd
  ];

  programs.git = {
    enable = true;
    userName = "roshan";
    userEmail = "roshanahegde@gmail.com";
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
    };
  };

  programs.nix-index.enableFishIntegration = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.command-not-found.enable = false;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.11";
}
