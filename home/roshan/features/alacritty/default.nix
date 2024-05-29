{ lib, config, pkgs, ... }: {
    programs.alacritty = {
        enable = true;
        settings = {
            window = {
                padding = { x = 10; y = 10; };
                opacity = lib.mkForce 0.5;
                blur = true;
            };
            keyboard.bindings = [
                { key = "N"; mods = "Control"; action = "SpawnNewInstance"; }
            ];
        };
    };

}
