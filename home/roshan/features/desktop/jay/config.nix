{
  lib,
  config,
  pkgs,
  inputs,
}:
let
  scheme = config.stylix.base16Scheme;
  color = name: "#${scheme.${name}}";
  wallpaper = builtins.toString config.stylix.image;

  terminal = "${pkgs.kitty}/bin/kitty";
  browser =
    let
      pkg = config.programs.firefox.package;
    in
    "${pkg}/bin/firefox";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pamixer = "${pkgs.pamixer}/bin/pamixer";

  jay = inputs.jay.packages.${pkgs.stdenv.hostPlatform.system}.jay;

  screenshot = pkgs.writeShellScript "jay-screenshot" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  displayToggle = pkgs.writeShellScript "jay-display-toggle" ''
    json=$(${jay}/bin/jay --json randr show)
    connectors=$(echo "$json" | ${pkgs.jq}/bin/jq -r '.drm_devices[].connectors[] | select(.output) | .name')
    for c in $connectors; do
      enabled=$(echo "$json" | ${pkgs.jq}/bin/jq -r --arg c "$c" '.drm_devices[].connectors[] | select(.name == $c) | .enabled')
      if [ "$enabled" = "true" ]; then
        ${jay}/bin/jay randr output "$c" disable
      else
        ${jay}/bin/jay randr output "$c" enable
      fi
    done
  '';

  execAction = cmd: {
    type = "exec";
    exec = cmd;
  };

  workspaces = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "q"
    "w"
    "e"
    "r"
    "t"
  ];
  directions = {
    h = "left";
    j = "down";
    k = "up";
    l = "right";
  };
  resizeDelta = {
    left = {
      dx1 = -15;
      dx2 = -15;
    };
    right = {
      dx1 = 15;
      dx2 = 15;
    };
    up = {
      dy1 = -15;
      dy2 = -15;
    };
    down = {
      dy1 = 15;
      dy2 = 15;
    };
  };

  workspaceShortcuts = lib.listToAttrs (
    lib.concatMap (n: [
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
    ]) workspaces
  );

  focusShortcuts = lib.mapAttrs' (key: dir: lib.nameValuePair "alt-${key}" "focus-${dir}") directions;
  moveShortcuts = lib.mapAttrs' (
    key: dir: lib.nameValuePair "alt-ctrl-${key}" "move-${dir}"
  ) directions;
  resizeShortcuts = lib.mapAttrs' (
    key: dir: lib.nameValuePair "alt-shift-${key}" ({ type = "resize"; } // resizeDelta.${dir})
  ) directions;

  baseShortcuts = {
    "alt-Return" = execAction terminal;
    "alt-f" = execAction browser;
    "alt-d" = execAction [
      "discord"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
    ];
    "alt-s" = execAction "${displayToggle}";
    "logo-s" = execAction "${screenshot}";
    "alt-shift-c" = "close";
    "alt-space" = "toggle-fullscreen";
    "alt-u" = "toggle-floating";
    "alt-p" = "toggle-float-pinned";
    "alt-shift-Tab" = "toggle-split";
  };
in
{
  repeat-rate = {
    rate = 50;
    delay = 200;
  };

  keymap.rmlvo = {
    model = "evdev";
    layout = "us";
  };

  auto-reload = true;
  show-bar = false;
  show-titles = false;
  window-management-key = "Alt_L";
  focus-follows-mouse = true;

  env = {
    XCURSOR_THEME = config.stylix.cursor.name;
    XCURSOR_SIZE = builtins.toString config.stylix.cursor.size;
  };

  on-graphics-initialized = execAction [
    "${pkgs.swaybg}/bin/swaybg"
    "-i"
    wallpaper
    "-m"
    "fill"
  ];

  theme = {
    border-width = 2;
    border-color = color "base0E";
    bg-color = color "base00";
  };

  clients = [
    {
      match.comm-regex = "wl-(copy|paste)";
      capabilities = "data-control";
    }
    {
      match.comm = "grim";
      capabilities = "screencopy";
    }
  ];

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
      match.serial-number = "0000000000001";
      mode = {
        width = 2560;
        height = 1440;
        refresh-rate = 164.999;
      };
      scale = 1.33333;
    }
  ];

  inputs = [
    {
      match.is-pointer = true;
      accel-profile = "adaptive";
    }
    {
      match.name = "<touchpad name from jay input>";
      natural-scrolling = true;
    }
    {
      match.name = "Razer Razer Viper V2 Pro"; # verify with `jay input`
      accel-profile = "flat";
      accel-speed = -0.4;
    }
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
      action = execAction [
        brightnessctl
        "s"
        "5%+"
      ];
    };
    XF86MonBrightnessDown = {
      mod-mask = "";
      action = execAction [
        brightnessctl
        "s"
        "5%-"
      ];
    };
    XF86AudioRaiseVolume = {
      mod-mask = "";
      action = execAction [
        pamixer
        "-i"
        "5"
      ];
    };
    XF86AudioLowerVolume = {
      mod-mask = "";
      action = execAction [
        pamixer
        "-d"
        "5"
      ];
    };
    XF86AudioMute = {
      mod-mask = "";
      action = execAction [
        pamixer
        "-t"
      ];
    };
  };

  shortcuts =
    baseShortcuts // workspaceShortcuts // focusShortcuts // moveShortcuts // resizeShortcuts;
}
