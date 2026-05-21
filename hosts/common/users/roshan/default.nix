{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (g: builtins.hasAttr g config.users.groups) groups;
in {
  users.users.roshan = {
    isNormalUser = true;
    extraGroups = ifTheyExist [
      "wheel"
      "networkmanager"
      "docker"
      "openrazer"
      "libvirtd"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys =
      pkgs.lib.splitString "\n" (builtins.readFile ../../../../home/roshan/ssh.pub);
  };

  home-manager.users.roshan = import ../../../../home/roshan/${config.networking.hostName}.nix;
}
