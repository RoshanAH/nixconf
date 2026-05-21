{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pamixer
    brightnessctl
    devenv
    waywall
    sbctl
  ];
}
