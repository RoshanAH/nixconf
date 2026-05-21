{
  pkgs,
  options,
  ...
}: {
  programs.nix-ld = {
    enable = true;
    libraries =
      options.programs.nix-ld.libraries.default
      ++ (with pkgs; [
        alsa-lib
        at-spi2-atk
        cairo
        cups
        dbus
        expat
        gdk-pixbuf
        glib
        gtk3
        gtk4
        nss
        nspr
        xorg.libX11
        xorg.libxcb
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxkbfile
        xorg.libxshmfence
        pango
        pciutils
        stdenv.cc.cc
        systemd
        libnotify
        pipewire
        libsecret
        libpulseaudio
        speechd-minimal
        libdrm
        mesa
        libxkbcommon
        libGL
        vulkan-loader
      ]);
  };
}
