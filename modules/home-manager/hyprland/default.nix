{ lib, config, pkgs, inputs, ... }: {
	imports = [
		./binds.nix		
        ./cursor.nix
	];
	xdg.portal = {
		extraPortals = [ pkgs.inputs.hyprland.xdg ];
	};
#    xdg.configFile."hypr/${builtins.baseNameOf config.stylix.image}" = {
#        source = config.stylix.image;
#    };
#    xdg.configFile."hypr/integrated-card" = {
#        source = "/dev/dri/by-path/pci-0000:04:00.0-card";
#    };
#    xdg.configFile."hypr/card" = {
#        source = "/dev/dri/by-path/pci-0000:01:00.0-card";
#    };

    home.packages = with pkgs; [
        wl-clipboard
        hyprpaper
        inputs.hyprland-contrib.packages.${pkgs.system}.grimblast 
    ];

    services.hyprpaper = {
        enable = true;
        settings = let
            path = builtins.toString config.stylix.image;
        in {
            preload = [ path ];
            wallpaper = [ ",${path}" ];
            splash = false;
        };
    };
	
	wayland.windowManager.hyprland = {
		enable = true;
        systemd = {
            enable = true;
            extraCommands = lib.mkBefore [
                "systemctl --user stop graphical-session.target"
                "systemctl --user start hyprland-session.target"
            ];
        };
		settings = let 
			terminal = "${pkgs.alacritty}/bin/alacritty";
			browser = "${pkgs.firefox}/bin/firefox";
			brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
			pamixer = "${pkgs.pamixer}/bin/pamixer";


            active = "rgba(${config.stylix.base16Scheme.base0E}ff) rgba(${config.stylix.base16Scheme.base05}ff) 60deg";
            inactive = "rgba(${config.stylix.base16Scheme.base00}ff)";
		in {
            exec-once = [
                "hyprpaper"
            ];
			monitor = [ "eDP-1,1920x1080@144,0x0,1" ",highrr,auto,1" ];
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

            device = let 
                sense = 0.0;
                accel = "flat";
                viperNames = [ "razer-razer-viper-v2-pro-1" "razer-razer-viper-v2-pro" ];
            in map (name: {
                inherit name;
                sensitivity = sense;
                accel_profile = accel;
            }) viperNames ++ [ /* other devices here */ ];


			dwindle = {
				no_gaps_when_only = 1;
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
                render_ahead_of_time = false;
                initial_workspace_tracking = 2;
				# Unfullscreen when opening something
				new_window_takes_over_fullscreen = 2;
			};
			decoration = {
				active_opacity = 1.0;
				inactive_opacity = 1.0;
				fullscreen_opacity = 1.0;
				rounding = 0;
				blur = {
					enabled = true;
					size = 5;
					passes = 3;
					new_optimizations = true;
					ignore_opacity = false;
				};
				drop_shadow = false;
			};

			animations = {
				enabled = true;
				bezier = [
					"snap,0.2,1,.5,1"
					"fling,.4,-0.5,1,.8"
					"push,.5,0,.5,1"
				];

				animation = [
					"windowsIn,1,3,snap,popin"
					"windowsOut,1,3,push,slide"
					"windowsMove,1,3,snap"
					"workspaces,0,2,snap,slide"
					"fadeIn,1,3,snap"
					"fadeOut,1,3,snap"
					"fadeSwitch,1,3,snap"
					"fadeShadow,1,3,snap"
					"fadeDim,1,3,snap"
					"border,1,3,snap"
				];
			};

			# program binds
			bind = [			
				"ALT,Return,exec,${terminal}"
				"ALT,f,exec,${browser}"
                "ALT,g,exec,qutebrowser"
                "ALT,d,exec, discord --enable-features=UseOzonePlatform --ozone-platform=wayland"
                "SUPER,s,exec,grimblast copy area"
			];
			binde = [
				",XF86MonBrightnessUp,exec,${brightnessctl} s 5%+"
				",XF86MonBrightnessDown,exec,${brightnessctl} s 5%-"
				",XF86AudioRaiseVolume,exec,${pamixer} -i 5"
				",XF86AudioLowerVolume,exec,${pamixer} -d 5"
				",XF86AudioMute,exec,${pamixer} -t"
			];
            bindl = let 
                monitorCheck = pkgs.writeShellScriptBin "monitor-check" ''
                if hyprctl monitors | grep -Pq 'Monitor (?!eDP-1)'; then
                    $@
                fi
                '' ;
            in[
                ",switch:on:Lid Switch,exec,${monitorCheck}/bin/monitor-check hyprctl keyword monitor eDP-1,disable"
                ",switch:off:Lid Switch,exec,${monitorCheck}/bin/monitor-check hyprctl keyword monitor eDP-1,1920x1080@144,0x0,1"
            ];

		};
	};
}
