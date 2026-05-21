{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (g: builtins.hasAttr g config.users.groups) groups;
in {
  users.users.guest = {
    isNormalUser = true;
    extraGroups = ifTheyExist ["networkmanager"];
    shell = pkgs.fish;
  };

  home-manager.users.guest = import ../../../../home/guest/${config.networking.hostName}.nix;
}
