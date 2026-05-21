{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.my.gpg;
in {
  options.my.gpg = {
    graphical = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to use graphical pinentry";
    };
  };

  config = {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = ["BCD3B35C286FAEFC5258211CFD5FD9A1908D9DC6"];
      enableExtraSocket = true;
      pinentry.package =
        if cfg.graphical
        then pkgs.pinentry-gnome3
        else pkgs.pinentry-tty;
    };

    home.packages = lib.optional cfg.graphical pkgs.gcr;

    programs = let
      fixGpg = ''
        gpgconf --launch gpg-agent
      '';
      fixYubikey = ''
        gpg-connect-agent 'scd serialno' 'learn --force' /bye
      '';
    in {
      bash.profileExtra = fixGpg;
      fish.loginShellInit = fixGpg;
      zsh.loginExtra = fixGpg;

      fish.shellAbbrs.yk = fixYubikey;
      bash.shellAliases.yk = fixYubikey;
      zsh.shellAliases.yk = fixYubikey;

      gpg = {
        enable = true;
        settings = {
          trust-model = "tofu+pgp";
          default-key = "0xE726000EF5F8FDB4";
          trusted-key = "0xE726000EF5F8FDB4";

          no-comments = true;
          no-emit-version = true;
          throw-keyids = true;

          require-secmem = true;
          no-symkey-cache = true;

          keyid-format = "0xlong";
          with-fingerprint = true;

          armor = true;
        };
        publicKeys = [
          {
            source = ../pgp.asc;
            trust = 5;
          }
        ];
      };
    };
  };
}
