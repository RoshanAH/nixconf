{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/roshan
    ../common/users/guest

    ../common/optional/networkmanager.nix
    ../common/optional/grub.nix
    ../common/optional/nix-minecraft.nix

    ../common/optional/syncthing.nix
  ];

  networking.hostName = "alienware";

  system.stateVersion = "23.11";
}
