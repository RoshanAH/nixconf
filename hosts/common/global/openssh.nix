{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";

      StreamLocalBindUnlink = "yes";
      GatewayPorts = "clientspecified";
      AcceptEnv = ["WAYLAND_DISPLAY"];
      X11Forwarding = true;
    };
  };

  security.pam.sshAgentAuth = {
    enable = true;
    authorizedKeysFiles = ["/etc/ssh/authorized_keys.d/%u"];
  };
}
