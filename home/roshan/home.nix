# This is your home-manager configuration file
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
	  ./features/hyprland
	  ./features/nvim
      ./features/alacritty
      inputs.nix-colors.homeManagerModules.default
  ];

  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-medium;

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
    firefox
    discord
    fzf
    ripgrep
    fd
    prismlauncher
  ];

  programs.qutebrowser = let
    inherit (config.colorscheme) palette mode;
  in {
      enable = true;
      settings = {
          colors = {
# Becomes either 'dark' or 'light', based on your colors!
              webpage.preferred_color_scheme = "${config.colorScheme.variant}";
              tabs.bar.bg = "#${config.colorScheme.palette.base00}";
              keyhint.fg = "#${config.colorScheme.palette.base05}";
          };
      };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = { 
    enable = true;
    userName = "roshan";
    userEmail = "roshanahegde@gmail.com";
    extraConfig = {
      credential.helper = "store";
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  programs.zsh.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
