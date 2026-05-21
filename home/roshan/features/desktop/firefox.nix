{pkgs, ...}: let
  customPass = pkgs.pass.withExtensions (ext: with ext; [pass-otp pass-import]);
  passff-host-custom = pkgs.passff-host.overrideAttrs (_old: {
    dontStrip = true;
    patchPhase = ''
      sed -i 's#COMMAND = "pass"#COMMAND = "${customPass}/bin/pass"#' src/passff.py
    '';
  });
in {
  xdg.configFile."mozilla/native-messaging-hosts/passff.json".source = "${passff-host-custom}/share/passff-host/passff.json";

  home.packages = [
    passff-host-custom
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [passff-host-custom];
  };
}
