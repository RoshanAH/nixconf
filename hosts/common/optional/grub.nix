{
  lib,
  config,
  ...
}: let
  cfg = config.my.grub;
in {
  options.my.grub = {
    windowsEntry = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Add a chainloader entry for an installed Windows EFI bootloader";
    };

    useOSProber = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable os-prober for grub";
    };
  };

  config = {
    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = cfg.useOSProber;
        timeoutStyle = "hidden";
        extraEntries = lib.mkIf cfg.windowsEntry ''
          menuentry "Windows" {
              insmod ntfs
              set root=(hd0,gpt1)
              chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
  };
}
