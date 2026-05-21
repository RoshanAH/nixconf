{pkgs, ...}: {
  stylix = {
    targets = {
      hyprland.enable = false;
      hyprpaper.enable = false;
      vim.enable = false;
      firefox.profileNames = ["default"];
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
    };
  };
}
