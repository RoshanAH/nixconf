{ lib
, config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./binds.nix
    ./cursor.nix
  ];

  home.packages =
    (with pkgs; [
      wl-clipboard
      hyprpaper
    ])
    ++ [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];

  services.hyprpaper = {
    enable = true;
    settings =
      let
        path = builtins.toString config.stylix.image;
      in
      {
        wallpaper = {
          monitor = "";
          inherit path;
          fit_mode = "cover";
        };
        splash = false;
      };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings =
      let
        terminal = "${pkgs.kitty}/bin/kitty";
        #terminal = "${pkgs.alacritty}/bin/alacritty";
        browser =
          let
            pkg = config.programs.firefox.package;
            name = "firefox";
          in
          "${pkg}/bin/${name}";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        pamixer = "${pkgs.pamixer}/bin/pamixer";

        active = "rgba(${config.stylix.base16Scheme.base0E}ff) rgba(${config.stylix.base16Scheme.base05}ff) 60deg";
        inactive = "rgba(${config.stylix.base16Scheme.base00}ff)";
      in
      {

        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "GLX_VENDOR_LIBRARY_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        ];

        exec-once = [
          "hyprpaper"
        ];
        monitor = [ 
          "eDP-1,1920x1080@144,0x0,1" 
          "desc:TTG GM-GFT-27FTQB 0000000000001,2560x1440@144.00Hz,auto,1.33333" 
          ",preferred,auto,1" 
        ];
        xwayland = {
          force_zero_scaling = true;
        };
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = lib.mkForce active;
          "col.inactive_border" = lib.mkForce inactive;
          #allow_tearing = true;
        };
        input = {
          accel_profile = "adaptive";
          sensitivity = 0.0;
          force_no_accel = false;
          touchpad.disable_while_typing = false;
          touchpad.natural_scroll = true;
          repeat_rate = 50;
          repeat_delay = 200;
          natural_scroll = false;
        };

        device =
          let
            sense = -0.40000;
            accel = "flat";
            viperNames = [ 
              "razer-razer-viper-v2-pro" 
              "razer-razer-viper-v2-pro-1" 
              "razer-razer-viper-v2-pro-2" 
              "razer-razer-viper-v2-pro-3" 
            ];
          in
          map
            (name: {
              inherit name;
              sensitivity = sense;
              accel_profile = accel;
            })
            viperNames
          ++ [
            /*
          other devices here
            */
          ];

        dwindle = {
          preserve_split = true;
          force_split = 2;
        };
        misc = {
          vfr = true;
          vrr = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          close_special_on_empty = true;
          focus_on_activate = true;
          initial_workspace_tracking = 1; # dont set to 2
        };
        decoration = {
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          fullscreen_opacity = 1.0;
          rounding = 0;
          blur = {
            # enabled = true;
            enabled = false;
            size = 5;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = false;
          };
          shadow.enabled = false;
        };

        workspace = [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrule = [
          "border_size 0, rounding 0, match:float 0, match:workspace w[tv1]"
          "border_size 0, rounding 0, match:float 0, match:workspace f[1]"
        ];

        animations = {
          enabled = false;
        };

        # program binds
        bind = [
          "ALT,Return,exec,${terminal}"
          "ALT,f,exec,${browser}"
          "ALT,d,exec,discord --enable-features=UseOzonePlatform --ozone-platform=wayland"
          "ALT,s,exec,spotify"
          "SUPER,s,exec,grimblast --freeze copy area"
          ", F9, pass, ^(com\.obsproject\.Studio)$" # obs replay buffer
        ];
        binde = [
          ",XF86MonBrightnessUp,exec,${brightnessctl} s 5%+"
          ",XF86MonBrightnessDown,exec,${brightnessctl} s 5%-"
          ",XF86AudioRaiseVolume,exec,${pamixer} -i 5"
          ",XF86AudioLowerVolume,exec,${pamixer} -d 5"
          ",XF86AudioMute,exec,${pamixer} -t"
        ];
        bindl =
          let
            monitorCheck = pkgs.writeShellScriptBin "monitor-check" ''
              if hyprctl monitors | grep -Pq 'Monitor (?!eDP-1)'; then
                  $@
              fi
            '';
          in
          [
            ",switch:on:Lid Switch,exec,${monitorCheck}/bin/monitor-check hyprctl keyword monitor eDP-1,disable"
            ",switch:off:Lid Switch,exec,${monitorCheck}/bin/monitor-check hyprctl keyword monitor eDP-1,1920x1080@144,0x0,1"
          ];
      };
  };
}
