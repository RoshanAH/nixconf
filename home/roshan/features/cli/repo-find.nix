{config, ...}: {
  my.repo-find = {
    enable = true;
    fishBindings = [
      {
        bind = "\\cp";
        directory = "${config.home.homeDirectory}/repos";
      }
    ];
  };
}
