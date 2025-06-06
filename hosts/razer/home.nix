# This is your home-manager configuration filehome
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports =
    let
      home-manager = [
        "hyprland"
        "nvim"
        "alacritty"
        "kitty"
        "fish.nix"
        "firefox.nix"
        "tmux.nix"
        "scripts/repo-find"
      ];
    in
      (map (module: ../../modules/home-manager + "/${module}") home-manager) ++
    [./mcsr];

  nixpkgs = {
    overlays = [ ];
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

  home.packages = (with pkgs; [
    discord
    fzf
    ripgrep
    fd
    musescore
    ffmpeg
    python3
    osu-lazer
  ]) ++ [
    inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
  ];

  repo-find = {
    enable = true;
    fishBindings = [
      {
        bind = "\\cp";
        directory = "${config.home.homeDirectory}/repos";
      }
    ];
  };

  stylix = {
    targets = {
      hyprland.enable = false;
      hyprpaper.enable = false;
      vim.enable = false;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };

    };
  };

  programs = {
    zsh.enable = true;
    command-not-found.enable = false;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    nix-index.enableFishIntegration = true;
    git = {
      enable = true;
      userName = "roshan";
      userEmail = "roshanahegde@gmail.com";
      extraConfig = {
        credential.helper = "store";
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };
    spotify-player.enable = true;
  };

  # wayland.windowManager.hyprland.settings.env = [ "AQ_DRM_DEVICES,${./integrated-card}" ];
   # wayland.windowManager.hyprland.settings.env = [ "AQ_DRM_DEVICES,/dev/dri/card1" ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
