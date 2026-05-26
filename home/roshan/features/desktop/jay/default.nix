{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
  cfg = import ./config.nix {inherit lib config pkgs inputs;};
in {
  home.packages = with pkgs; [
    swaybg
    grim
    slurp
    wl-clipboard
  ];

  xdg.configFile."jay/config.toml".source =
    tomlFormat.generate "jay-config.toml" cfg;
}
