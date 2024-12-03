{ pkgs,
  ... 
}: {
  programs.nixvim = {

    plugins = {
      nix.enable = true;
      ts-autotag.enable = true;
      transparent.enable = true;
      nvim-autopairs.enable = true;
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
          scheme-medium
          changepage
          arydshln
          mleftright
          preprint
          paralist
          framed
          ntheorem
          datenumber
          enumitem
          titlesec
          fontawesome5
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

          views = {
            mini = {
              win_options = {
                winblend = 0;
              };
            };
          };

        };
      };

    };
    # extraPackages = with pkgs; [
    #   texlivePackages.framed
    #   texliveMedium
    # ];
  };
}
