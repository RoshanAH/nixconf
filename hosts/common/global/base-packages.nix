{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    unzip
    sl
    tree
    jq
  ];
}
