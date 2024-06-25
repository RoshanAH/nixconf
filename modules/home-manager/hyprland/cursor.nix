{ pkgs, ... }: let 
    size = "32";
in {
    home.file = let
        bibataModernIce = pkgs.stdenv.mkDerivation {
            name = "bibata-modern-ice";
            src = pkgs.fetchurl {
                url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/1.0/hypr_Bibata-Modern-Ice.tar.gz";
                sha256 = "1y1c3mll5bx2qnv8xqam4vk6x1saxh56v248pknk7xgbg7l4dnyy";
            };
            sourceRoot = ".";

            installPhase = ''
            mkdir -p $out
            mv hyprcursors manifest.hl $out
            '';
        };
    in {
     ".local/share/icons/Bibata-Modern-Ice-hl".source = bibataModernIce;
    };

    stylix.cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
    };

    wayland.windowManager.hyprland.settings = {
        env = [ "HYPRCURSOR_THEME,Bibata-Modern-Ice" "HYPRCURSOR_SIZE,${size}"  ];
        exec-once = [ "hyprctl setcursor Bibata-Modern-Ice ${size}" ];
        cursor = {
            inactive_timeout = 4;
            no_hardware_cursors = false;
        };
    };
}
