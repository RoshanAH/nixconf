{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.programs.waywall;
  mcsrPkgs = inputs.mcsr-nixos.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.mcsr-nixos.homeManagerModules.waywall ];

  options = {
    programs.waywall = {
      width = lib.mkOption {
        type = lib.types.int;
        default = 1920;
      };

      height = lib.mkOption {
        type = lib.types.int;
        default = 1080;
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      (prismlauncher.override {
        additionalLibs = [
          jemalloc
          libxtst
          libxkbcommon
          libxt
          libxinerama
        ];
      })
    ];

    programs.waywall = {
      enable = true;
      config = {
        enableWaywork = true;
        programs = [ mcsrPkgs.ninjabrain-bot ];
        files = {
          eye_overlay = ./eye-overlay.png;
          bg = config.stylix.image;
        };

        text = ''
          local resolution = { w = ${toString cfg.width}, h = ${toString cfg.height} }
        ''
        + builtins.readFile ./waywall.lua;
      };
    };
  };
}
