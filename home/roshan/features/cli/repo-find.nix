{
  config,
  lib,
  pkgs,
  ...
}: let
  bindings = [
    {
      bind = "\\cp";
      directory = "${config.home.homeDirectory}/repos";
    }
  ];
  bindToStr = {
    bind,
    directory,
  }: ''
    bind -M normal ${bind} "cd (${lib.getExe pkgs.repo-find} ${directory}); commandline -f repaint"
    bind -M insert ${bind} "cd (${lib.getExe pkgs.repo-find} ${directory}); commandline -f repaint"
  '';
in {
  home.packages = [pkgs.repo-find];

  programs.fish.interactiveShellInit = lib.concatLines (map bindToStr bindings);
}
