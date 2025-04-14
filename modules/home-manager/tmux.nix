{ lib, pkgs, config, inputs, ...}: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
           set -g @resurrect-processes 'ssh psql mysql sqlite3'
           set -g @resurrect-strategy-nvim 'session'
           resurrect_dir=~/.local/share/tmux/resurrect
           set -g @resurrect-dir $resurrect_dir
           set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/nix/store/.*/bin/||g' $(readlink -f $resurrect_dir/last)"
        '';
      }
      {
        plugin = fingers;
        extraConfig = ''
          unbind F
          unbind f
          set -g @fingers-key fc
          set -g @fingers-key fj
        '';
      }
      pain-control
    ];
    mouse = true;
    sensibleOnTop = true;
    prefix = "C-Space";
    baseIndex = 1;
    
    extraConfig = ''
      bind r source-file ${config.home.homeDirectory}/.config/tmux/tmux.conf
      set-option -g status-position top
    '';
  };
}
