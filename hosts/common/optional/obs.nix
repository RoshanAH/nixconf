{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.my.obs;
in {
  options.my.obs = {
    cudaSupport = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Build OBS with NVIDIA CUDA support";
    };
  };

  config = {
    programs.obs-studio = {
      enable = true;

      package =
        if cfg.cudaSupport
        then pkgs.obs-studio.override {cudaSupport = true;}
        else pkgs.obs-studio;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
