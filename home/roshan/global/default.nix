{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = builtins.attrValues outputs.homeModules;

  home = {
    username = "roshan";
    homeDirectory = "/home/roshan";
    stateVersion = "23.11";
  };

  home.file.".ssh/id_yubikey.pub".source = ../ssh.pub;

  programs.command-not-found.enable = false;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.nix-index.enableFishIntegration = true;
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "roshan";
      user.email = "roshanahegde@gmail.com";
      credential.helper = "${lib.getExe pkgs.pass-git-helper}";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  systemd.user.startServices = "sd-switch";
}
