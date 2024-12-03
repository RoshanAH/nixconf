_: {
  programs.nixvim = {

    diagnostics = {
      virtual_text = false;
    };

    plugins = {
      otter.enable = true;

      # lsp
      lsp = {
        enable = true;
        servers = {
          tailwindcss.enable = true; # TailwindCSS
          html.enable = true; # HTML
          svelte.enable = true; # Svelte
          pyright.enable = true; # Python
          marksman.enable = true; # Markdown
          nil_ls.enable = true; # Nix
          bashls.enable = true; # Bash
          clangd.enable = true; # C/C++
          yamlls.enable = true; # YAML


          lua_ls = { # Lua
            enable = true;
            settings.telemetry.enable = false;
          };

          ltex = { # latex
            enable = true;
            settings.ltex-ls.logLevel = "info";
          };

          # Rust
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
        };
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
          "ga" = "code_action";
          "gr" = "rename";
          "gf" = "format";
        };
        keymaps.diagnostic = {
          "gl" = "open_float";
        };
      };

      none-ls = {
        enable = true;
        settings = {
          debug = true;
        };
        sources = {
          code_actions = {
            statix.enable = true;
          };
          diagnostics = {
            statix.enable = true;
            deadnix.enable = true;
            pylint.enable = true;
            checkstyle.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            stylua.enable = true;
            shfmt.enable = true;
            nixpkgs_fmt.enable = true;
            google_java_format.enable = false;
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
            black = {
              enable = true;
              settings = ''
                {
                extra_args = { "--fast" },
                }
              '';

            };
          };
          completion = {
            luasnip.enable = true;
            #spell.enable = true;
          };
        };
      };

      # cmp
      cmp = {
        enable = true;
        settings = {
            autoEnableSources = true;
            performance = {
              debounce = 60;
              fetchingTimeout = 200;
              maxViewEntries = 30;
            };
            snippet = { expand = "luasnip"; };
            formatting = { fields = [ "kind" "abbr" "menu" ]; };
            sources = [
              { name = "nvim_lsp"; }
              {
                name = "buffer"; # text within current buffer
                option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                keywordLength = 3;
              }
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];

          window = {
            completion = { border = "solid"; };
            documentation = { border = "solid"; };
          };

          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<S-CR>" = "cmp.mapping.confirm({ select = true })";
            # "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };
      cmp-nvim-lsp.enable = true; # LSP
      cmp-buffer.enable = true;
      cmp-path.enable = true; # file system paths
      cmp_luasnip.enable = true; # snippets
      cmp-cmdline.enable = true; # autocomplete for cmdline

      lspkind = {
        enable = true;
        extraOptions = {
          maxwidth = 50;
          ellipsis_char = "...";
        };
      };
    };

    autoCmd = [
      # Auto otter activate
      {
        command = "lua require('otter').activate()";
        event = [
          "BufEnter"
        ];
        pattern = [
          "*.nix"
          "*.md"
          "*.tex"
        ];
      }
    ];

  };
}
