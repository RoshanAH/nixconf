{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
    ./features/desktop/jay
    ./features/gpg.nix
    ./features/pass.nix
    ./features/mcsr
  ];

  my.gpg.graphical = true;

  my.jay.config.drm-devices = [
    {
      name = "integrated";
      # AMD Granite Ridge [Radeon Graphics]
      match = {
        pci-vendor = 4098; # 0x1002
        pci-model = 5056; # 0x13c0
      };
    }
    {
      name = "dedicated";
      # AMD Navi 48 [Radeon RX 9070/9070 XT/9070 GRE]
      match = {
        pci-vendor = 4098; # 0x1002
        pci-model = 30032; # 0x7550
      };
      gfx-api = "Vulkan";
    }
  ];

  my.jay.config.render-device.name = "dedicated";
}
