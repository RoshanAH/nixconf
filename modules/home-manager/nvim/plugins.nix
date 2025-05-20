{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      nix.enable = true;
      ts-autotag.enable = true;
      transparent.enable = true;
      # nvim-autopairs.enable = true;
      luasnip.enable = true;

      telescope = {
        enable = true;
        extensions = {
          fzf-native = {
            enable = true;
          };
        };
        keymaps = {
          "<leader>fs" = "lsp_dynamic_workspace_symbols";
          "<leader>fr" = "lsp_references";
        };
      };

      mini = {
        enable = true;
        modules.icons = { };
        mockDevIcons = true;
      };

      vimtex = {
        enable = true;
        settings = {
          view_method = "zathura";
        };
        texlivePackage = pkgs.texlive.withPackages (ps:
          with ps; [
            scheme-full
          ]);
      };

      molten = {
        enable = true;
        python3Dependencies = p:
          with p; [
            pynvim
            jupyter-client
            cairosvg
            pnglatex
            plotly
            pyperclip
            ipython
            nbformat
          ];
      };

      fugitive = {
        enable = true;
      };

      undotree = {
        enable = true;
        settings = {
          autoOpenDiff = true;
          focusOnToggle = true;
        };
      };

      lualine = {
        enable = true;
        settings = {
          options = {
            icons_enabled = true;
            theme = "auto";
            section_separators = {
              left = "█";
              right = "█";
            };
            component_separators = {
              left = "╱";
              right = "╱";
            };
            always_divide_middle = true;
            always_show_tabline = true;
            globalstatus = false;
            refresh = {
              statusline = 100;
              tabline = 100;
              winbar = 100;
            };
          };
          sections = {
            lualine_a = [ "mode" ];
            lualine_b = [ "branch" "diagnostics" ];
            lualine_c = [ "filename" ];
            lualine_x = [ "" ] ;
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
          inactive_sections = {
            lualine_x = null;
          };
        };
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      noice = {
        enable = true;
        settings = {
          presets = {
            long_message_to_split = true;
            lsp_doc_border = true;
          };

          lsp = {
            hover.enabled = true;
            progress.enabled = false;
            override = {
              "cmp.entry.get_documentation" = true;
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
            };
          };

          views = {
            mini = {
              win_options = {
                winblend = 0;
              };
            };
          };
          routes = [
            {
              view = "notify";
              filter = { event = "msg_showmode"; };
            }
          ];
        };
      };
    };
    # extraPackages = with pkgs; [
    #   texlivePackages.framed
    #   texliveMedium
    # ];
  };
}
