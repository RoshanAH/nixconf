{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pamixer
    brightnessctl
    devenv
    sbctl
  ];
}
