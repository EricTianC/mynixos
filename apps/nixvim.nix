{lib, pkgs, ...}:
{
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
    };

    globals.mapleader = "<space>";
    # globals.maplocalleader = "<space><space>";

    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      number = true;
      relativenumber = true;

      foldcolumn = "auto";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      fillchars = {
				eob = " ";
				fold = " ";
				foldopen = "";
				foldsep = " ";
				# foldinner = " ";
				foldclose = "";
			};
      
    };

    keymaps = [
      # textobjects related keymaps
      {
        mode = ["x" "o"];
        key = "aa";
        action.__raw = ''function() require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects") end'';
        options.desc = "Select [a]round the outer part of a p[a]rameter";
      }
      {
        mode = ["x" "o"];
        key = "ia";
        action.__raw = ''function() require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects") end'';
        options.desc = "Select the [i]nner part of a p[a]rameter";
      }
      {
        mode = ["x" "o"];
        key = "as";
        action.__raw = ''function() require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals") end'';
        options.desc = "Select the [i]nner part of a p[a]rameter";
      }
      # treesitter-textobjects swap and jump scope

      {
        mode = ["n"];
        key = "<leader>a";
        action.__raw = ''function() require "nvim-treesitter-textobjects.swap".swap_next "@parameter.inner" end'';
      }
      {
        mode = ["n"];
        key = "<leader>A";
        action.__raw = ''function() require "nvim-treesitter-textobjects.swap".swap_previous "@parameter.outer" end'';
      }

      {
        mode = ["n" "x" "o"];
        key = "]m";
        action.__raw = ''function() require "nvim-treesitter-textobjects.move".goto_next_start("@function.outer", "textobjects") end'';
      }
      {
        mode = ["n" "x" "o"];
        key = "[m";
        action.__raw = ''function() require "nvim-treesitter-textobjects.move".goto_previous_start("@function.outer", "textobjects") end'';
      }
      {
        mode = ["n" "x" "o"];
        key = "]s";
        action.__raw = ''function() require "nvim-treesitter-textobjects.move".goto_next_start("@local.scope", "locals") end'';
      }
      {
        mode = ["n" "x" "o"];
        key = ";";
        action.__raw = ''require "nvim-treesitter-textobjects.repeatable_move".repeat_last_move_next'';
      }
      {
        mode = ["n" "x" "o"];
        key = ",";
        action.__raw = ''require "nvim-treesitter-textobjects.repeatable_move".repeat_last_move_previous'';
      }


      # flash.nvim
      {
        mode = ["n" "x" "o"];
        key = "s";
        action.__raw = ''function() require("flash").jump() end'';
        options.desc = "Flash";
      }
      {
        mode = ["n" "x" "o"];
        key = "S";
        action.__raw = ''function() require("flash").treesitter() end'';
        options.desc = "Flash Treesitter";
      }
    ];

    clipboard = {
      register = "unnamedplus";
      providers = {
        wl-copy.enable = true;
      };
    };

    plugins = {
      web-devicons.enable = true;
      statuscol = {
        enable = true;
        settings = {
          bt_ignore = null;
          clickhandlers = {
            FoldClose = "require('statuscol.builtin').foldclose_click";
            FoldOpen = "require('statuscol.builtin').foldopen_click";
            FoldOther = "require('statuscol.builtin').foldother_click";
            Lnum = "require('statuscol.builtin').lnum_click";
          };
          clickmod = "c";
          ft_ignore = null;
          relculright = true;
          segments = [
            {
              click = "v:lua.ScFa";
              text = [
                "%C"
              ];
            }
            {
              click = "v:lua.ScSa";
              text = [
                "%s"
              ];
            }
            {
              click = "v:lua.ScLa";
              condition = [
                true
                {
                  __raw = "require('statuscol.builtin').not_empty";
                }
              ];
              text = [
                {
                  __raw = "require('statuscol.builtin').lnumfunc";
                }
                " "
              ];
            }
          ];
          setopt = true;
          thousands = ".";
        };
      };
      nvim-ufo.enable = true;
      nvim-surround.enable = true;
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;
      };
      treesitter-textobjects = {
        enable = true;
        # settings.select = {
        #   enable = true;
        #   lookahead = true;
        #   keymaps = {
        #     "aa" = "@parameter.outer";
        #     "ab" = "@block.outer";
        #     "ac" = "@call.outer";
        #     "ia" = "@parameter.inner";
        #     "ib" = "@block.inner";
        #     "ic" = "@call.inner";
        #   };
        # };
      };
      lualine.enable = true;
      nvim-tree.enable = true;
      telescope.enable = true;
      flash.enable = true;
      noice.enable = true;
      bufferline.enable = true;
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<c-\\>]]";
          shell = "fish";
        };
      };
      lsp-format = {
        enable = true;
      };
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
          };
          clangd = {
            enable = true;
            package = null;
          };
          zls = {
            enable = true;
            package = null;
          };
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
        settings.snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
      };
      dap = {
        enable = true;
      };
      luasnip = {
        enable = true;
        fromVscode = [
          {lazyLoad = true;}
        ];
      };
      lean = {
        enable = true;
        settings = {
          mapping = true;
          abbreviations = {
            enable = true;
          };
          lsp = {
            enable = true;
          };
          infoview = {
            autoopen = true;
            orientation = "auto";
            indicators = "auto";
          };
        };
      };
      flutter-tools = {
        enable = true;
      };
      vimtex = {
        enable = true;
        texlivePackage = null;
        settings = {
          view_method = "zathura";
        };
      };
      cmp-vimtex.enable = true;
    # snacks.enable = true;
    };

    dependencies = {
      fd.enable = true;
      lean = {
        enable = true;
        packageFallback = true;
      };
      flutter = {
        enable = false;
        package = null;
      };
    };
  };
}
