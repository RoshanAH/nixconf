{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
    ./features/gpg.nix
    ./features/pass.nix
  ];

  my.gpg.graphical = true;
}
