{pkgs, ...}: {
  xdg = {
    enable = true;
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = ["*"];
      xdgOpenUsePortal = true;
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/about" = ["firefox.desktop"];
        "x-scheme-handler/unknown" = ["firefox.desktop"];
        "text/html" = ["firefox.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop" "firefox.desktop"];
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
