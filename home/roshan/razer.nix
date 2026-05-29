{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
    ./features/desktop/gpu-select.nix
    ./features/mcsr
    ./features/gpg.nix
    ./features/pass.nix
  ];

  my.gpg.graphical = true;
}
