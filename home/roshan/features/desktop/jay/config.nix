{
  lib,
  config,
  pkgs,
  inputs,
}: let
  scheme = config.stylix.base16Scheme;
  color = name: "#${scheme.${name}}";
  wallpaper = builtins.toString config.stylix.image;

  terminal = "${pkgs.kitty}/bin/kitty";
  browser = let
    pkg = config.programs.firefox.package;
  in "${pkg}/bin/firefox";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pamixer = "${pkgs.pamixer}/bin/pamixer";

  jay = inputs.jay.packages.${pkgs.stdenv.hostPlatform.system}.jay;

  screenshot = pkgs.writeShellScript "jay-screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  # Hyprland's `dpms toggle` analog. Jay has no stateful toggle verb, so flip a
  # flag file and enable/disable the connectors. Verify names with `jay randr`.
  displayToggle = pkgs.writeShellScript "jay-display-toggle" ''
    connectors="eDP-1"
    flag="$XDG_RUNTIME_DIR/jay-display-toggle"
    if [ -f "$flag" ]; then
      for c in $connectors; do ${jay}/bin/jay randr output "$c" enable; done
      rm -f "$flag"
    else
      for c in $connectors; do ${jay}/bin/jay randr output "$c" disable; done
      touch "$flag"
    fi
  '';

  # exec helper: pass a string (bare program) or list (program + args)
  execAction = cmd: {
    type = "exec";
    exec = cmd;
  };

  workspaces = ["1" "2" "3" "4" "5" "q" "w" "e" "r" "t"];
  # arrow/hjkl key -> jay direction word
  directions = {
    h = "left";
    j = "down";
    k = "up";
    l = "right";
  };
  resizeDelta = {
    left = {dx2 = -15;};
    right = {dx2 = 15;};
    up = {dy2 = -15;};
    down = {dy2 = 15;};
  };

  workspaceShortcuts = lib.listToAttrs (lib.concatMap (n: [
      {
        name = "alt-${n}";
        value = {
          type = "show-workspace";
          name = n;
        };
      }
      {
        name = "alt-shift-${n}";
        value = {
          type = "move-to-workspace";
          name = n;
        };
      }
    ])
    workspaces);

  focusShortcuts =
    lib.mapAttrs' (key: dir: lib.nameValuePair "alt-${key}" "focus-${dir}") directions;
  moveShortcuts =
    lib.mapAttrs' (key: dir: lib.nameValuePair "alt-ctrl-${key}" "move-${dir}") directions;
  resizeShortcuts =
    lib.mapAttrs' (key: dir:
      lib.nameValuePair "alt-shift-${key}" ({type = "resize";} // resizeDelta.${dir}))
    directions;

  baseShortcuts = {
    "alt-Return" = execAction terminal;
    "alt-f" = execAction browser;
    "alt-d" = execAction ["discord" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"];
    "alt-s" = execAction "${displayToggle}";
    "logo-s" = execAction "${screenshot}";
    "alt-shift-c" = "close";
    "alt-space" = "toggle-fullscreen";
    "alt-u" = "toggle-floating";
    "alt-p" = "toggle-float-pinned";
    "alt-shift-Tab" = "toggle-split";
    "alt-Tab" = "focus-prev"; # no swap-children equivalent; closest analog
  };
in {
  repeat-rate = {
    rate = 50;
    delay = 200;
  };

  show-bar = false;
  window-management-key = "Alt_L"; # ALT + left/right mouse to move/resize
  focus-follows-mouse = true;

  env = {
    LIBVA_DRIVER_NAME = "nvidia";
    GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    XCURSOR_THEME = config.stylix.cursor.name;
    XCURSOR_SIZE = builtins.toString config.stylix.cursor.size;
  };

  on-graphics-initialized = execAction ["${pkgs.swaybg}/bin/swaybg" "-i" wallpaper "-m" "fill"];

  theme = {
    border-width = 2;
    border-color = color "base0E";
    bg-color = color "base00";
  };

  # Monitors. Match values (model/connector) should be confirmed with `jay randr`.
  outputs = [
    {
      name = "internal";
      match.connector = "eDP-1";
      mode = {
        width = 1920;
        height = 1080;
        refresh-rate = 144.0;
      };
      x = 0;
      y = 0;
      scale = 1.0;
    }
    {
      name = "external";
      match.model = "GM-GFT-27FTQB"; # verify via `jay randr`
      mode = {
        width = 2560;
        height = 1440;
        refresh-rate = 165.0;
      };
      scale = 1.33333;
    }
  ];

  inputs = [
    # Global pointer acceleration (Hyprland: accel_profile = adaptive)
    {
      match.is-pointer = true;
      accel-profile = "adaptive";
    }
    # Touchpad natural scrolling (match by name; confirm with `jay input`)
    {
      match.name = "<touchpad name from jay input>";
      natural-scrolling = true;
    }
    # Razer Viper V2 Pro: flat accel, slowed sensitivity (Hyprland sense -0.4)
    {
      match.name = "Razer Razer Viper V2 Pro"; # verify with `jay input`
      accel-profile = "flat";
      accel-speed = -0.4;
    }
    # Laptop lid switch (unconditional unlike the old monitor-aware Hyprland bind)
    {
      match.is-switch = true;
      on-lid-closed = {
        type = "configure-connector";
        connector = {
          match.name = "eDP-1";
          enabled = false;
        };
      };
      on-lid-opened = {
        type = "configure-connector";
        connector = {
          match.name = "eDP-1";
          enabled = true;
        };
      };
    }
  ];

  complex-shortcuts = {
    XF86MonBrightnessUp = {
      mod-mask = "";
      action = execAction [brightnessctl "s" "5%+"];
    };
    XF86MonBrightnessDown = {
      mod-mask = "";
      action = execAction [brightnessctl "s" "5%-"];
    };
    XF86AudioRaiseVolume = {
      mod-mask = "";
      action = execAction [pamixer "-i" "5"];
    };
    XF86AudioLowerVolume = {
      mod-mask = "";
      action = execAction [pamixer "-d" "5"];
    };
    XF86AudioMute = {
      mod-mask = "";
      action = execAction [pamixer "-t"];
    };
  };

  shortcuts =
    baseShortcuts
    // workspaceShortcuts
    // focusShortcuts
    // moveShortcuts
    // resizeShortcuts;
}
