{
  config,
  ...
}:
{
  sops.secrets."syncthing/key" = {
    sopsFile = ../../../hosts/${config.networking.hostName}/secrets.yaml;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    user = "roshan";
    configDir = "/home/roshan/.config/syncthing";

    # Override all settings set from the GUI.  This is necessary if I don't want
    # to have changes made from the GUI apply.
    overrideDevices = true;
    overrideFolders = true;

    cert = toString ../../../hosts/${config.networking.hostName}/syncthing-cert.pem;
    key = config.sops.secrets."syncthing/key".path;

    # Settings: this is where you set up devices and folders
    settings = {
      devices = {
        "razer" = {
          id = "5UECL4R-NRNE7TC-YOJCMYL-4KT4GJ4-QIUDE4X-BTID3MH-L3IXU4R-PBBVDQ5";
        };
        "alienware" = {
          id = "7YQMCPE-TQGQAMF-GSP5BP7-QPCOSRV-2JCRTSC-T43ZHFP-7XMC3FK-XWZ35QV";
        };
        "juno" = {
          id = "HC33LVK-BALFHEU-MYUSLSM-P6UCZKK-DFG34FK-7YTHHV6-GRY25YO-6XYLYAN";
        };
      };

      folders = {
        "sync" = {
          path = "/home/roshan/sync";
          devices = [
            "razer"
            "alienware"
            "juno"
          ];
        };
        "nixconf" = {
          path = "/home/roshan/nixconf";
          devices = [
            "razer"
            "alienware"
            "juno"
          ];
        };
        "mc-instances" = {
          path = "/home/roshan/.local/share/PrismLauncher/instances";
          devices = [
            "razer"
            "alienware"
            "juno"
          ];
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "1";
          };
        };
      };
    };
  };
}
