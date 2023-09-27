local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Navigation plugins
  'nvim-tree/nvim-web-devicons',
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  },
  'ggandor/leap.nvim',
  'nacro90/numb.nvim',
  'kevinhwang91/rnvimr',

  -- UI Plugins
  { 'rebelot/heirline.nvim' },
    'SmiteshP/nvim-navic',
    'altercation/vim-colors-solarized',
    'willothy/nvim-cokeline',
    'akinsho/toggleterm.nvim',
    'kevinhwang91/nvim-hlslens',
    'petertriho/nvim-scrollbar',
    'goolord/alpha-nvim',
    'lukas-reineke/indent-blankline.nvim',
    'beauwilliams/focus.nvim',
    'folke/zen-mode.nvim',
    'folke/twilight.nvim',
    'jedrzejboczar/possession.nvim',
    'jedrzejboczar/toggletasks.nvim',
    'declancm/cinnamon.nvim',
    'stevearc/dressing.nvim',
    {'kevinhwang91/nvim-ufo', dependencies = {'kevinhwang91/promise-async'}},
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
        }
    },

  -- editor plugins
    'numtostr/comment.nvim',
    'editorconfig/editorconfig-vim',
    'windwp/nvim-autopairs',
    'kylechui/nvim-surround',
    'lewis6991/gitsigns.nvim',
    {
        'glacambre/firenvim',

        -- Lazy load firenvim
        -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
        lazy = not vim.g.started_by_firenvim,
        build = function()
            vim.fn["firenvim#install"](0)
        end
    },
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- { 'michaelb/sniprun', build = 'bash ./install.sh' },
    'windwp/nvim-spectre',
    { 'mizlan/iswap.nvim' },

  -- lsp plugins
    'neovim/nvim-lspconfig',
    'kosayoda/nvim-lightbulb',
    'weilbith/nvim-code-action-menu',
    'nvim-lua/lsp-status.nvim',
    {'glepnir/lspsaga.nvim', branch = 'main'},
    'simrat39/symbols-outline.nvim',
    'folke/trouble.nvim',
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'nvim-treesitter/playground',
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/nvim-treesitter-refactor' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    'p00f/nvim-ts-rainbow',
    { 'jose-elias-alvarez/null-ls.nvim' },
    'mfussenegger/nvim-jdtls',
    'JoosepAlviste/nvim-ts-context-commentstring',
    {
      url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    },

  -- cmp
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-calc',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'petertriho/cmp-git',
    'lukas-reineke/cmp-rg',
    'honza/vim-snippets',
    'rafamadriz/friendly-snippets',
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },
    'onsails/lspkind-nvim',
    'uga-rosa/cmp-dictionary',

    'norcalli/nvim-colorizer.lua',
    'connorholyday/vim-snazzy',
    'folke/which-key.nvim',
    { 
      'anuvyklack/hydra.nvim',
      dependencies = {'anuvyklack/keymap-layer.nvim'} -- needed only for pink hydras
    },

  -- language specific
    {"ellisonleao/glow.nvim", branch = 'main'}, --markdown preview,
  -- this one dont need update for now
    { 'p00f/cphelper.nvim', pin = true },
  }, 
  -- opts
  {
    checker = {
      enabled = true,
    }
  }
)

