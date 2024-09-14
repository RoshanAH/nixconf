{ lib
, config
, pkgs
, ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.5;
    };
  };
}
