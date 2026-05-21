{
  lib,
  pkgs,
  ...
}: {
  programs.fish.loginShellInit = lib.mkBefore ''
    if not set -q TMUX
      if uwsm check may-start
        ${pkgs.gpu-select}/bin/gpu-select
      end
    end
  '';
}
