{ lib, config, pkgs, ... }: {
    programs.alacritty = {
        enable = true;
        settings = {
            window = {
                padding = { x = 10; y = 10; };
#                opacity = 0.3;
                blur = true;
            };
            keyboard.bindings = [
                { key = "N"; mods = "Control"; action = "SpawnNewInstance"; }
            ];
        };
    };

}
