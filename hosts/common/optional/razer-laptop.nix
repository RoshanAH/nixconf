{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.razerdaemon.nixosModules.default];

  services.razer-laptop-control.enable = true;

  hardware.openrazer = {
    enable = true;
    users = ["roshan"];
  };

  environment.systemPackages = with pkgs; [
    polychromatic
    openrazer-daemon
  ];
}
