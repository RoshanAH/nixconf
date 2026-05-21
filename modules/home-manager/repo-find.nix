{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) types mkEnableOption mkOption mkIf concatLines;
  cfg = config.my.repo-find;
in {
  options.my.repo-find = {
    enable = mkEnableOption "repo-find";
    fishBindings = let
      fishBindOptions.options = {
        bind = mkOption {
          type = types.str;
          description = "Keybind for fish shell";
        };
        directory = mkOption {
          type = types.str;
          default = "";
          description = "Directory to search in";
        };
      };
    in
      mkOption {
        type = types.listOf (types.submodule fishBindOptions);
        default = [];
        description = "Binds for fish shell";
      };
  };

  config = let
    fishEnabled = config.programs.fish.enable;
    pkg = pkgs.callPackage ../../pkgs/repo-find {};
  in
    mkIf cfg.enable {
      home.packages = [pkg];
      programs.fish.interactiveShellInit = let
        bindToStr = {
          bind,
          directory,
        }: ''
          bind -M normal ${bind} "cd (${pkg}/bin/${pkg.name} ${directory}); commandline -f repaint"
          bind -M insert ${bind} "cd (${pkg}/bin/${pkg.name} ${directory}); commandline -f repaint"
        '';
      in
        mkIf fishEnabled ''
          ${concatLines (map bindToStr cfg.fishBindings)}
        '';
    };
}
