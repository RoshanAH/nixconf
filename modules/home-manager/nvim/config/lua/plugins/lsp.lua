return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'onsails/lspkind.nvim',
        config = function()
            require('lspkind').init({
                mode = 'symbol_text',
                preset = 'default',
                symbol_map = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",
                },
            })
        end
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
            {'onsails/lspkind.nvim'},
            -- {'jmbuhr/otter.nvim'},
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                sources = {
                    {name = 'nvim_lsp'},
                    -- {name = 'otter'},
                    {name = 'buffer'},
                    {name = 'path'},
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = {
                    ['<Tab>'] = cmp_action.luasnip_supertab(),
                    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
                    ['<C-y>'] = cmp.mapping.confirm({select = false}),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
                    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
                    ['<C-p>'] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item({behavior = 'insert'})
                        else
                            cmp.complete()
                        end
                    end),
                    ['<C-n>'] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_next_item({behavior = 'insert'})
                        else
                            cmp.complete()
                        end
                    end),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                format = require('lspkind').cmp_format({
                    mode = 'symbol',
                    maxwidth = 50,
                    ellipsis_char = '...',
                    show_labelDetails = true,
                })
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({buffer = bufnr})
                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr})
                vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, {buffer = bufnr})
                vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, {buffer = bufnr})
            end)

            lsp_zero.set_sign_icons({
              error = '✖',
              warn = '▲',
              hint = '⚑',
              info = '»'
            })

            vim.diagnostic.config({
                virtual_text = false,
                severity_sort = true,
            })


            local lua_opts = lsp_zero.nvim_lua_ls()
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup(lua_opts)

            local servers = require("plugins.servers")

            for _, server in ipairs(servers) do
                if lspconfig[server] then
                    lspconfig[server].setup({})
                end
            end
        end
    }
}
