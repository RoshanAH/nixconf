{ lib, config, pkgs, ... }: {
	imports = [
		./binds.nix		
	];
	xdg.portal = {
		extraPortals = [ pkgs.inputs.hyprland.xdg ];
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
		in {
			monitor = [ ",highrr,auto,1" ];
			general = {
				cursor_inactive_timeout = 4;
				gaps_in = 5;
				gaps_out = 10;
				border_size = 1;
#			"col.active_border" = active;
#			"col.inactive_border" = inactive;
			};
			input = {
				touchpad.disable_while_typing = false;
				touchpad.natural_scroll = true;
				repeat_rate = 50;
				repeat_delay = 200;
				natural_scroll = false;
			};
			device = [
				{
					name = "razer-razer-viper-v2-pro-1";
					sensitivity = -0.5;
				}
				{
					name = "razer-razer-viper-v2-pro";
					sensitivity = -0.5;
				}
			];
			dwindle = {
				no_gaps_when_only = 1;
				preserve_split = true;
				force_split = 2;
			};
			misc = {
				vfr = true;
				disable_hyprland_logo = true;
				disable_splash_rendering = true;
				close_special_on_empty = true;
				focus_on_activate = true;
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

			];
			binde = [
				",XF86MonBrightnessUp,exec,${brightnessctl} s 5%+"
				",XF86MonBrightnessDown,exec,${brightnessctl} s 5%-"
				",XF86AudioRaiseVolume,exec,${pamixer} -i 5"
				",XF86AudioLowerVolume,exec,${pamixer} -d 5"
				",XF86AudioMute,exec,${pamixer} -t"
			];
		};
	};
}
