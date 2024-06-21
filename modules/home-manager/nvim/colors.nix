{ config, ... }: {
    xdg.configFile."nvim/lua/plugins/colors.lua".text = let
        palette = config.stylix.base16Scheme;
    in '' 
    return {
        {
            'RRethy/base16-nvim',
            lazy = false,

            config = function()
                require('base16-colorscheme').setup({
                        base00 = "#${palette.base00}",
                        base01 = "#${palette.base01}",
                        base02 = "#${palette.base02}",
                        base03 = "#${palette.base03}",
                        base04 = "#${palette.base04}",
                        base05 = "#${palette.base05}",
                        base06 = "#${palette.base06}",
                        base07 = "#${palette.base07}",
                        base08 = "#${palette.base08}",
                        base09 = "#${palette.base09}",
                        base0A = "#${palette.base0A}",
                        base0B = "#${palette.base0B}",
                        base0C = "#${palette.base0C}",
                        base0D = "#${palette.base0D}",
                        base0E = "#${palette.base0E}",
                        base0F = "#${palette.base0F}",
                })

--                vim.api.nvim_set_hl(0, 'Normal', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'NonText', { bg = 'none', ctermbg = 'none' })
--
--                vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'Folded', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'none', ctermbg = 'none' })
--
--                vim.api.nvim_set_hl(0, 'DiagnosticSignError', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { bg = 'none', ctermbg = 'none' })
--                vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { bg = 'none', ctermbg = 'none' })
                end
        },
        {
            'xiyaowong/transparent.nvim',
            lazy = false,
            config = function() 
                require("transparent").setup({ -- Optional, you don't have to run setup.
                    groups = { -- table: default groups
                        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
                        'EndOfBuffer',
                    },
                    extra_groups = {}, -- table: additional groups that should be cleared
                    exclude_groups = {}, -- table: groups you don't want to clear
                    vim.cmd("TransparentEnable")
                })
            end
        },

    } '';
}
