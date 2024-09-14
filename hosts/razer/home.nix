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
        "fish.nix"
        "firefox.nix"
      ];
    in
    map (module: ../../modules/home-manager + "/${module}") home-manager;

  nixpkgs = {
    overlays = [
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

  stylix.targets = {
    hyprland.enable = false;
    hyprpaper.enable = false;
    vim.enable = false;
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

  #  wayland.windowManager.hyprland.settings.env = [ "WLR_DRM_DEVICES,${./integrated-card}" ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
