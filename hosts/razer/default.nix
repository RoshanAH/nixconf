{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/roshan

    ../common/optional/networkmanager.nix
    ../common/optional/yubikey.nix
    ../common/optional/stylix.nix
    ../common/optional/pipewire.nix
    ../common/optional/bluetooth.nix
    ../common/optional/hyprland.nix
    ../common/optional/jay.nix
    ../common/optional/nvidia.nix
    ../common/optional/razer-laptop.nix
    ../common/optional/tlp.nix
    ../common/optional/nix-ld-electron.nix
    ../common/optional/steam.nix
    ../common/optional/obs.nix
    ../common/optional/flatpak.nix
    ../common/optional/qmk.nix
    ../common/optional/grub.nix
    ../common/optional/nixvim.nix
    ../common/optional/desktop-packages.nix
    ../common/optional/syncthing.nix
  ];

  networking.hostName = "razer";

  my.grub.windowsEntry = true;
  my.obs.cudaSupport = true;

  boot.kernelParams = ["button.lid_init_state=open"];

  system.stateVersion = "23.11";
}
