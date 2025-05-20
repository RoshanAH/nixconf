{ lib
, ...
}: {
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
  };
  programs.kitty = {
    enable = true;
    keybindings = {
      "0x1008ff57" = "copy_to_clipboard";
      "0x1008ff6d" = "paste_from_clipboard";
      "ctrl+n" = "new_os_window_with_cwd";
    };
    settings = {
      # background_opacity = lib.mkForce "0.5";
      # background_opacity = lib.mkForce "0.9";
      linux_display_server = "wayland";
      scrollback_lines = 4000;
      scrollback_pager_history_size = 100000;
      window_padding_width = 10;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
    };
    shellIntegration.enableFishIntegration = true;
  };
}
