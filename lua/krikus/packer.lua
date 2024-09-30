vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'lukas-reineke/cmp-under-comparator'
  use 'rcarriga/nvim-notify'
  use 'wbthomason/packer.nvim'
  use 'WhoIsSethDaniel/mason-tool-installer.nvim'
  use 'praem90/nvim-phpcsf'
  use 'lukas-reineke/indent-blankline.nvim'
  use {
    'nvim-pack/nvim-spectre',
    requires = { { 'nvim-lua/plenary.nvim' } },
  }
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use {
    'm4xshen/smartcolumn.nvim',
    config = function()
      require('smartcolumn').setup({
        colorcolumn = "120",
        disabled_filetypes = { "help", "text", "markdown", "NvimTree", "lazy", "mason", "help", "checkhealth", "lspinfo", "noice", "Trouble", "fish", "zsh" },
        scope = "file",
      })
    end
  }
  use {
    'mcauley-penney/visual-whitespace.nvim',
    config = function()
      require('visual-whitespace').setup({
        opts = {
          highlight = { link = 'Visual' },
          space_char = '.',
          tab_char = '→',
          nl_char = '↵',
        }
      })
    end
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    -- or , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' }, { "nvim-telescope/telescope-live-grep-args.nvim" } },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  }

  -- theme
  -- use {
    --   'catppuccin/nvim',
    --   config = function()
      --     vim.opt.termguicolors = true
      --     vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
      --     require("catppuccin").setup()
      --     vim.cmd("colorscheme catppuccin")
      --   end
      -- }


      use {
        'savq/melange-nvim',
        config = function()
          vim.opt.termguicolors = true
          vim.cmd('colorscheme melange')
        end
      }

      use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
          --- Uncomment the two plugins below if you want to manage the language servers from neovim
          { 'williamboman/mason.nvim' },
          { 'williamboman/mason-lspconfig.nvim' },

          -- LSP Support
          { 'neovim/nvim-lspconfig' },
          -- Autocompletion
          { 'hrsh7th/nvim-cmp' },
          { 'hrsh7th/cmp-nvim-lsp' },
          { 'L3MON4D3/LuaSnip' },
          -- https://lsp-zero.netlify.app/v3.x/blog/theprimeagens-config-from-2022.html
          { 'hrsh7th/cmp-buffer' },
          { 'hrsh7th/cmp-path' },
          { 'saadparwaiz1/cmp_luasnip' },
          { 'hrsh7th/cmp-nvim-lua' },
          { 'L3MON4D3/LuaSnip' },
          { 'rafamadriz/friendly-snippets' }
        }
      }


      use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
      use('theprimeagen/harpoon')
      use('mbbill/undotree')
      use('tpope/vim-fugitive')
      use('nvim-tree/nvim-tree.lua')
      use('nvim-tree/nvim-web-devicons')
      use({
        'Exafunction/codeium.vim',
        config = function()
          vim.keymap.set('i', '<C-y>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
          --- vim.keymap.set('i', '<c-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
          vim.keymap.set('i', '<C-n>', function() return vim.fn['codeium#CycleCompletions'](1) end,
          { expr = true, silent = true })
          vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
        end
      })
      use({
        "aznhe21/actions-preview.nvim",
        requires = {
          { 'nvim-telescope/telescope.nvim' },
        },
        config = function()
          vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
        end,
      })
      use({
        "sontungexpt/sttusline",
        branch = "table_version",
        requires = {
          "nvim-tree/nvim-web-devicons",
        },
        event = { "BufEnter" },
        config = function(_, opts)
          require("sttusline").setup {
            on_attach = function(create_update_group) end,

            -- the colors of statusline will be set follow the colors of the active buffer
            -- statusline_color = "#fdff00",
            statusline_color = "StatusLine",
            disabled = {
              filetypes = {
                "NvimTree",
                -- "lazy",
              },
              buftypes = {
                "terminal",
              },
            },
            -- the components of statusline
            -- https://github.com/sontungexpt/sttusline
            components = {
              "mode",
              "os-uname",
              "filename",
              "git-branch",
              "git-diff",
              "%=",
              "diagnostics",
              "lsps-formatters",
              --"copilot",
              --"copilot-loading",
              "indent",
              "encoding",
              "pos-cursor",
              "pos-cursor-progress",
            },
          }
        end
      })
      use("mg979/vim-visual-multi")
      use({
        'smoka7/hop.nvim',
        tag = '*', -- optional but strongly recommended
        config = function()
          -- you can configure Hop the way you like here; see :h hop-config
          require 'hop'.setup { keys = 'abcdefghijklmnopqrstuvwxyz' }
        end
      })
      use {
        'numToStr/Comment.nvim',
        config = function()
          require('Comment').setup()
        end
      }

      use 'f-person/git-blame.nvim'

      use({
        'romgrk/barbar.nvim',
        requires = {
          'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
          'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        config = function()
          vim.g.barbar_auto_setup = false
        end
      })

      use({
        'rust-lang/rust.vim',
        ft = 'rust',
        config = function()
          vim.g.rustfmt_autosave = 1
        end
      })

      use({
        "kylechui/nvim-surround",
        tag = "*",         -- Use for stability; omit to use `main` branch for the latest features
      })

      use({
        "norcalli/nvim-colorizer.lua",
        config = function()
          require("colorizer").setup()
        end
      })
      use {
        'HallerPatrick/py_lsp.nvim',
        config = function()
          require'py_lsp'.setup {
            default_venv_name = ".venv" -- For local venv
          }
        end
      }
    end)

