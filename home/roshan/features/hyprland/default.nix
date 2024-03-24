{ lib, config, pkgs, ... }: {
	imports = [
		./binds.nix		
	];
	xdg.portal = {
		extraPortals = [ pkgs.inputs.hyprland.xdg ];
	};
	
	wayland.windowManager.hyprland = {
		enable = true;
		# TODO systemd stuff here when hyprland is stable
	};
	settings = let 
			terminal = "${pkgs.alacritty}/bin/alacritty";
			browser = "${pkgs.firefox}/bin/firefox";
		in {
		general = {
			cursor_inactive_timeout = 4;
			gaps_in = 15;
			gaps_out = 20;
			border_size = 2;
#			"col.active_border" = active;
#			"col.inactive_border" = inactive;
		};
		input = {
			kb_layout = "br,us";
			touchpad.disable_while_typing = false;
		};
		misc = {
			vfr = true;
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
				"easein,0.11, 0, 0.5, 0"
				"easeout,0.5, 1, 0.89, 1"
				"easeinback,0.36, 0, 0.66, -0.56"
				"easeoutback,0.34, 1.56, 0.64, 1"
			];

			animation = [
				"windowsIn,1,3,easeoutback,slide"
				"windowsOut,1,3,easeinback,slide"
				"windowsMove,1,3,easeoutback"
				"workspaces,0,2,easeoutback,slide"
				"fadeIn,1,3,easeout"
				"fadeOut,1,3,easein"
				"fadeSwitch,1,3,easeout"
				"fadeShadow,1,3,easeout"
				"fadeDim,1,3,easeout"
				"border,1,3,easeout"
			];
		};

		# program binds
		bind = [			
			"ALT,Return,exec,${terminal}"
			"ALT,f,exec,${browser}"
			
		];
		bindr = [
			",XF86MonBrightnessUp,exec,${brightnessctl} s 5%+"
			",XF86MonBrightnessDown,exec,${brightnessctl} s 5%-"

			",XF86AudioRaiseVolume,exec,${pamixer} -i 5"
			",XF86AudioLowerVolume,exec,${pamixer} -d 5"
			",XF86AudioMute,exec,${pamixer} -t"
		];
	};
}
