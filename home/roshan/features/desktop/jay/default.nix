{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
  baseConfig = import ./config.nix {inherit lib config pkgs inputs;};
in {
  options.my.jay.config = lib.mkOption {
    type = tomlFormat.type;
    default = {};
    description = ''
      Jay compositor configuration. Serialized to ~/.config/jay/config.toml.

      The base configuration is defined in ./config.nix; additional settings
      (e.g. my.jay.config.drm-devices) deep-merge into it, so GPU-specific
      tweaks can live alongside host configuration in e.g. juno.nix.
    '';
  };

  config = {
    my.jay.config = baseConfig;

    home.packages = with pkgs; [
      swaybg
      grim
      slurp
      wl-clipboard
    ];

    xdg.configFile."jay/config.toml".source =
      tomlFormat.generate "jay-config.toml" config.my.jay.config;
  };
}
