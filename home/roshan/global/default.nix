{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  home = {
    username = "roshan";
    homeDirectory = "/home/roshan";
    stateVersion = "23.11";
    file.".ssh/id_yubikey.pub".source = ../ssh.pub;
    packages = [
      inputs.tinker.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  programs = {
    command-not-found.enable = false;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    nix-index.enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "roshan";
      user.email = "roshanahegde@gmail.com";
      credential.helper = "${lib.getExe pkgs.pass-git-helper}"; # TODO this is broken
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  systemd.user.startServices = "sd-switch";
}
