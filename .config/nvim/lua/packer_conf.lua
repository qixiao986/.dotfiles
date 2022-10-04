-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

vim.cmd[[source $HOME/.config/nvim/plugin/packer_compiled.lua]]
local packer = require('packer')
packer.reset()
packer.init({
  display = {
    open_fn = require'packer.util'.float
  }
})

packer.startup(function()
  use 'wbthomason/packer.nvim'

  -- Navigation plugins
  use { 'kyazdani42/nvim-web-devicons', opt = false }
  use {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }
  use 'ggandor/leap.nvim'
  use { 'nacro90/numb.nvim' }
  use 'kevinhwang91/rnvimr'

  -- UI Plugins
  use { 'rebelot/heirline.nvim' }
  use 'SmiteshP/nvim-navic'
  use 'altercation/vim-colors-solarized'
  use 'noib3/nvim-cokeline'
  use 'akinsho/toggleterm.nvim'
  use 'kevinhwang91/nvim-hlslens'
  use 'petertriho/nvim-scrollbar'
  use 'goolord/alpha-nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'beauwilliams/focus.nvim'
  use { 'folke/zen-mode.nvim' }
  use { 'folke/twilight.nvim' }
  use { 'jedrzejboczar/possession.nvim' }
  use { 'jedrzejboczar/toggletasks.nvim' }
  use 'declancm/cinnamon.nvim'
  use { 'stevearc/dressing.nvim' }
  use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}

  -- editor plugins
  use 'numtostr/comment.nvim'
  use 'editorconfig/editorconfig-vim'
  use 'windwp/nvim-autopairs'
  use 'kylechui/nvim-surround'
  use 'lewis6991/gitsigns.nvim'
  use { 'chentoast/marks.nvim', lock = true }
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'michaelb/sniprun', run = 'bash ./install.sh' }
  use 'windwp/nvim-spectre'
  -- use { 'github/copilot.vim', disable = true }
  use { 'mizlan/iswap.nvim' }

  -- lsp plugins
  use 'neovim/nvim-lspconfig'
  use 'kosayoda/nvim-lightbulb'
  use 'weilbith/nvim-code-action-menu'
  use 'nvim-lua/lsp-status.nvim'
  use {'glepnir/lspsaga.nvim', branch = 'main'}
  use 'simrat39/symbols-outline.nvim'
  use 'folke/trouble.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'nvim-treesitter/nvim-treesitter-refactor' }
  use { 'nvim-treesitter/nvim-treesitter-context' }
  use 'p00f/nvim-ts-rainbow'
  use { 'jose-elias-alvarez/null-ls.nvim', disable = false }
  use 'mfussenegger/nvim-jdtls'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  })

  -- cmp
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-calc'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'petertriho/cmp-git'
  use 'lukas-reineke/cmp-rg'
  use 'honza/vim-snippets'
  use 'rafamadriz/friendly-snippets'
  use { 'L3MON4D3/LuaSnip' }
  use { 'saadparwaiz1/cmp_luasnip' }
  use 'onsails/lspkind-nvim'
  use 'uga-rosa/cmp-dictionary'

  use 'norcalli/nvim-colorizer.lua'
  use 'connorholyday/vim-snazzy'
  use 'folke/which-key.nvim'
  use { 'anuvyklack/hydra.nvim',
    requires = 'anuvyklack/keymap-layer.nvim' -- needed only for pink hydras
  }

  -- language specific
  use {"ellisonleao/glow.nvim", branch = 'main'} --markdown preview
  -- this one dont need update for now
  use { 'p00f/cphelper.nvim', lock = true }
end)

