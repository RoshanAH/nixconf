{
  inputs,
  pkgs,
  ...
}: let
  jay = inputs.jay.packages.${pkgs.stdenv.hostPlatform.system}.jay;
in {
  # jay installs share/wayland-sessions/jay.desktop and the xdg-desktop-portal
  # portal files, so this is enough to register Jay as a selectable Wayland
  # session alongside Hyprland.
  environment.systemPackages = [jay];
}
