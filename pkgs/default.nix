{hyprland}: final: prev: {
  waywall-glfw = final.callPackage ./waywall-glfx.nix {};
  hyprtoplr = final.callPackage ./hyprtoplr.nix {inherit hyprland;};
}
