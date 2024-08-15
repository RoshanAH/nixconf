# This is your home-manager configuration filehome
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
	  ../../modules/home-manager/hyprland
	  ../../modules/home-manager/nvim
      ../../modules/home-manager/alacritty
      ../../modules/home-manager/fish.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
        inputs.prismlauncher.overlays.default
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "roshan";
    homeDirectory = "/home/roshan";
  };

  home.packages = with pkgs; [
    discord
    fzf
    ripgrep
    fd
    prismlauncher
    musescore
    ffmpeg
  ];

  #stylix.image = ./wallpapers/houses.jpg;
  #stylix.polarity = "dark";

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git


  stylix.targets = {
      hyprland.enable = false;
      hyprpaper.enable = false;
      vim.enable = false;
  };

  programs.git = { 
    enable = true;
    userName = "roshan";
    userEmail = "roshanahegde@gmail.com";
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.nix-index.enableFishIntegration = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh.enable = true;
  programs.command-not-found.enable = false;

#  wayland.windowManager.hyprland.settings.env = [ "WLR_DRM_DEVICES,${./integrated-card}" ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
