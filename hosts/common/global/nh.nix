{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 21d --keep 5";
    flake = "/home/roshan/nixconf";
  };
}
