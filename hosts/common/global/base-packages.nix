{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    neofetch
    unzip
    sl
    tree
    jq
  ];
}
