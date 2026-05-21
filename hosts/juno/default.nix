{inputs, ...}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/roshan

    ../common/optional/networkmanager.nix
    ../common/optional/yubikey.nix
    ../common/optional/stylix.nix
    ../common/optional/pipewire.nix
    ../common/optional/bluetooth.nix
    ../common/optional/hyprland.nix
    ../common/optional/steam.nix
    ../common/optional/obs.nix
    ../common/optional/flatpak.nix
    ../common/optional/qmk.nix
    ../common/optional/grub.nix
    ../common/optional/nixvim.nix
    ../common/optional/desktop-packages.nix
  ];

  networking.hostName = "juno";

  my.grub.useOSProber = true;

  system.stateVersion = "23.11";
}
