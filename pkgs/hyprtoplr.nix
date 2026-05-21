{
  lib,
  hyprlandPlugins,
  hyprland,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:
hyprlandPlugins.mkHyprlandPlugin {
  inherit hyprland;
  pluginName = "hyprtoplr";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "SsubezZ";
    repo = "hyprtoplr";
    rev = "9882a45d7f4d7d4f7d8b4e1a3a9bd4e7259d50ed";
    hash = "sha256-AQzPO1LQ+1g2XbSBWa/gWXFhGdOhWi7dqxVSERSo/uE=";
  };

  nativeBuildInputs = [cmake pkg-config];

  meta = with lib; {
    homepage = "https://github.com/SsubezZ/hyprtoplr";
    description = "Hyprland plugin for temporarily toggling top layer plugins above fullscreen windows";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [];
  };
}
