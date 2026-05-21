{
  pkgs,
  ...
}: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/sync/.password-store";
    };
    package = pkgs.pass.withExtensions (p: [
      p.pass-otp
      p.pass-import
    ]);
  };
}
