{
  programs.fish.loginShellInit = ''
    if not set -q TMUX
      if uwsm check may-start
        exec uwsm start hyprland-uwsm.desktop
      end
    end
  '';
}
