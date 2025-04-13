{ pkgs,
  ... 
}: {
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
      };
      mini = {
        enable = true;
        modules.icons = {

        };
        mockDevIcons = true;
      };

      vimtex = {
        enable = true;
        settings = {
          view_method = "zathura";
        };
        texlivePackage = pkgs.texlive.withPackages ( ps: with ps; [
          scheme-full
        ]);
      };

      molten = {
        enable = true;
        python3Dependencies = p: with p; [
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
              filter = { event = "msg_showmode";};
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
