{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
    ./features/desktop/jay
    ./features/desktop/gpu-select.nix
    ./features/mcsr
    ./features/gpg.nix
    ./features/pass.nix
  ];

  my.gpg.graphical = true;

  my.jay.config.env = {
    LIBVA_DRIVER_NAME = "nvidia";
    GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
