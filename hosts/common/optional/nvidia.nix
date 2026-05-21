{
  config,
  pkgs,
  ...
}: {
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.xserver.videoDrivers = ["nvidia"];
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:4:0:0";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    vdpauinfo
    vulkan-tools
    vulkan-validation-layers
    libvdpau-va-gl
    egl-wayland
    wgpu-utils
    mesa
    libglvnd
    nvitop
    libGL
  ];
}
