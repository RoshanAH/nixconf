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

    xdg.configFile = let

        recursiveRead = let
            helper = root: path: let
                fullpath = if path == "" then root else "${root}/${path}";
                isDir = builtins.readFileType fullpath == "directory";
            in if isDir then let
                dir = builtins.attrNames (builtins.readDir fullpath);
                prefix = if path == "" then  "" else "${path}/";
            in builtins.concatLists (map (file: helper root "${prefix}${file}") dir)
            else [ path ];
        in path: helper path "";

        files = recursiveRead ./config;
        out = builtins.listToAttrs (map (filename: { name = "nvim/${filename}"; value = { source = "${./config}/${filename}"; }; }) files);
    in out;


#	xdg.configFile = {
#        nvim = {
#            source = ./config;
#            recursive = true;
#        };
##        "lua/plugins/servers.lua".text = ''
##        {
##            ${lib.concatStrings (map ( { cfgName, ... }: cfgName + ", \n" ) lspServers)}
##        }
##        '';
#    };
}
