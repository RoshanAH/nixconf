{ lib, config
, pkgs
}: with lib; {
  options.repo-find = {

    enabled = mkEnableOption "repo-find";
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
    in mkOption {
      type = types.listOf (types.submodule fishBindOptions);
      default = [];
      description = "Binds for fish shell";
    };

  };

  config = let
      pkg = pkgs.callPackage ./package.nix {};
    in mkIf options.repo-find.enabled {
    home.packages = [
        pkg
    ];
    programs.fish.interactiveShellInit = let 
      bindToStr = {bind, directory}: 
        "bind ${bind} cd (${pkg}/bin/${pkg.pname} ${directory})";
      in mkIf config.programs.fish.enabled
      concatLines (map bindToStr options.fishBindings);
  };
}
