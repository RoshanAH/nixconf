# This is your home-manager configuration filehome
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  imports =
    [
      ../../modules/home/hyprland
      ../../modules/home/nvim
      ../../modules/home/kitty
      ../../modules/home/fish.nix
      ../../modules/home/firefox.nix
      ../../modules/home/tmux.nix
      ../../modules/home/gpg.nix
      ../../modules/home/pass.nix
      ../../modules/home/scripts/repo-find
    ];

  my.gpg.graphical = true;

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "roshan";
    homeDirectory = "/home/roshan";
  };

  home.file.".ssh/id_yubikey.pub".source = ../../keys/ssh.pub;

  home.packages = (with pkgs; [
    discord
    fzf
    ripgrep
    fd
    ffmpeg
    python3
    prismlauncher
    btop
  ]);

  xdg = {
    enable = true;
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "*" ];
      xdgOpenUsePortal = true;
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura.desktop" "firefox.desktop" ];
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

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
    zathura.enable = true;
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
        credential.helper = "${lib.getExe pkgs.pass-git-helper}";
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
