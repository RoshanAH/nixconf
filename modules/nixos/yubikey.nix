{ pkgs, ... }:
{
  programs.ssh.startAgent = false;

  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
  ];

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  environment.interactiveShellInit = ''
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1
  '';

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];
}
