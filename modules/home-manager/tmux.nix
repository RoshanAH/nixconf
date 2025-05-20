{ lib, pkgs, config, inputs, ...}: {
  programs.tmux = {
    enable = true;
    plugins = let 
        tp = pkgs.tmuxPlugins;
      in [
      {
        plugin = tp.resurrect;
        extraConfig = ''
           set -g @resurrect-processes 'ssh psql mysql sqlite3'
           set -g @resurrect-strategy-nvim 'session'
           resurrect_dir=~/.local/share/tmux/resurrect
           set -g @resurrect-dir $resurrect_dir
           set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/nix/store/.*/bin/||g' $(readlink -f $resurrect_dir/last)"
        '';
      }
      {
        plugin = tp.fingers;
        extraConfig = ''
          unbind F
          unbind f
          set -g @fingers-key f
        '';
      }
      tp.pain-control
      {
        plugin = tp.mkTmuxPlugin {
          pluginName = "stash";
          version = "0.0.1";
          rtpFilePath = "stash.tmux";
          src = pkgs.fetchFromGitHub {
            repo = "tmux-stash";
            owner = "RoshanAH";
            rev = "fc104a5a9af195c6e7f443d0318ec2ebf23d2c89";
            hash = "sha256-mdA9QpAPH3LcHM9qPST1M55NhNSh+In+XljjBHLSNVg=";
          };
        };
      }
      # {
      #   plugin = tp.gruvbox;
      #   extraConfig = ''
      #     set -g @tmux-gruvbox-statusbar-alpha 'true'
      #   '';
      # }
      {
        plugin = tp.mkTmuxPlugin {
          pluginName = "tmux-gruvbox";
          version = "0.0.1";
          rtpFilePath = "gruvbox.tmux";
          src = pkgs.fetchFromGitHub {
            repo = "tmux-gruvbox";
            owner = "z3z1ma";
            rev = "8f71abd479e60f9a663abdc42e06491b7e8e6a25";
            hash = "sha256-wBhOKM85aOcV4jD7wdyB/zXKDdhODE5k1iud+cm6Wk0=";
          };
        };
        extraConfig = ''
          set -g @gruvbox_flavour 'dark'

          set -g @gruvbox_window_left_separator "█"
          set -g @gruvbox_window_right_separator "█"
          set -g @gruvbox_window_number_position "right"
          set -g @gruvbox_window_middle_separator " █"

          set -g @gruvbox_window_default_fill "number"
          set -g @gruvbox_window_default_text "#W"

          set -g @gruvbox_window_current_fill "number"
          set -g @gruvbox_window_current_text "#W"

          set -g @gruvbox_status_modules_right "date_time"
          set -g @gruvbox_status_modules_left "session"
          set -g @gruvbox_status_left_separator  "█"
          set -g @gruvbox_status_right_separator "█"
          set -g @gruvbox_status_right_separator_inverse "no"
          set -g @gruvbox_status_fill "all"
          set -g @gruvbox_status_connect_separator "no"
        '';
      }
    ];
    mouse = true;
    escapeTime = 0;
    sensibleOnTop = true;
    prefix = "C-Space";
    baseIndex = 1;
    
    extraConfig = ''
      bind r source-file ${config.home.homeDirectory}/.config/tmux/tmux.conf
      set-option -g status-position top
    '';
  };
}
