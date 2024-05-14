{ lib, config, pkgs, ... }: let

    lspServers = with pkgs; [
        { pkg = sumneko-lua-language-server; cfgName = "lua_ls"; }
    ];

in {

	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
        extraPackages = map ({ pkg, ... }: pkg) lspServers;
    };


	xdg.configFile = {
        nvim = {
            source = ./config;
            recursive = true;
        };
#        "lua/plugins/servers.lua".text = ''
#        {
#            ${lib.concatStrings (map ( { cfgName, ... }: cfgName + ", \n" ) lspServers)}
#        }
#        '';
    };
}
