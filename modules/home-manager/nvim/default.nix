{ lib
, config
, pkgs
, inputs
, ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./opts.nix
    ./maps.nix
    ./plugins.nix
    ./lsp.nix
  ];

  programs.nixvim = {
    enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      harpoon2
    ];

    # extraPackages = with pkgs; [
    #   python3
    # ];

    extraConfigLua =
      /*
      * lua *
      */
      ''
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
                key = function()
                    return vim.loop.cwd()
                end,
            },
        })
        -- REQUIRED

        vim.keymap.set("n", "<leader>a", function() harpoon:list():prepend() end)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
      '';
  };
}
