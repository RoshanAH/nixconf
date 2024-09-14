{ lib
, config
, pkgs
, ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.5";
      linux_display_server = "wayland";
      wayland_enable_ime = "no";
      scrollback_lines = 4000;
      scrollback_pager_history_size = 100000;
      window_padding_width = 15;
      hide_window_decorations = "yes";
    };
    shellIntegration.enableFishIntegration = true;
  };
}
