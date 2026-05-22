{
  outputs,
  pkgs,
  ...
}: {
  home = {
    username = "guest";
    homeDirectory = "/home/guest";
    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    fd
  ];

  programs.command-not-found.enable = false;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.nix-index.enableFishIntegration = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "roshan";
      user.email = "roshanahegde@gmail.com";
      credential.helper = "store";
      init.defaultBranch = "main";
    };
  };

  systemd.user.startServices = "sd-switch";
}
