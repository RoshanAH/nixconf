{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
    ./features/gpg.nix
    ./features/pass.nix
    ./features/mcsr
  ];

  my.gpg.graphical = true;
}
