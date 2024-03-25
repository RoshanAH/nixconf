{ lib, ... }: { wayland.windowManager.hyprland.settings = let
      workspaces = [
        "1" "2" "3" "4" "5" "q" "w" "e" "r" "t"
      ];
      # Map keys (arrows and hjkl) to hyprland directions (l, r, u, d)
      directions = rec {
        left = "l"; right = "r"; up = "u"; down = "d";
        h = left; l = right; k = up; j = down;
      };

      shiftAmount = "15";
      pixelDelta = {
	      "l" = "-${shiftAmount} 0";
	      "r" = "${shiftAmount} 0";
	      "u" = "0 -${shiftAmount}";
	      "d" = "0 ${shiftAmount}";
      };

    in {
    bindm = [
      "ALT,mouse:272,movewindow"
      "ALT,mouse:273,resizewindow"
    ];

    bind = [
      "ALTSHIFT,c,killactive"

      "ALT,space,fullscreen,"
      "ALTSHIFT,space,fakefullscreen,"
      "ALT,u,togglefloating"
      "ALT,tab,layoutmsg,swapsplit"
      "ALTSHIFT,tab,layoutmsg,togglesplit"
    ] ++
    # Change workspace
    (map (n:
      "ALT,${n},workspace,name:${n}"
    ) workspaces) ++
    # Move window to workspace
    (map (n:
      "ALTSHIFT,${n},movetoworkspacesilent,name:${n}"
    ) workspaces) ++
    # Move focus
    (lib.mapAttrsToList (key: direction:
      "ALT,${key},movefocus,${direction}"
    ) directions) ++
    # Move windows
    (lib.mapAttrsToList (key: direction:
      "ALTCONTROL,${key},swapwindow,${direction}"
    ) directions);
    binde = 
    # Resizing
    (lib.mapAttrsToList (key: direction:
	 "ALTSHIFT,${key},resizeactive,${pixelDelta.${direction}}"
    ) directions);
  };
}
