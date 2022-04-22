-- Concise way to escape termcodes
local function t(str)
    -- Adjust boolean arguments as needed
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.g.mapleader = t'<Space>'
vim.g.maplocalleader = t'<Space>'

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
  use 'kyazdani42/nvim-tree.lua'
  use 'ggandor/lightspeed.nvim'
  use { 'ms-jpq/chadtree', branch='chad', run = 'python3 -m chadtree deps' }

  -- UI Plugins
  use 'nvim-lualine/lualine.nvim'
  use 'altercation/vim-colors-solarized'
  use 'akinsho/bufferline.nvim'
  use 'akinsho/toggleterm.nvim'
  use 'kevinhwang91/nvim-hlslens'
  use 'petertriho/nvim-scrollbar'
  use 'goolord/alpha-nvim'
  use 'lukas-reineke/indent-blankline.nvim'

  -- editor plugins
  use 'numtostr/comment.nvim'
  use 'editorconfig/editorconfig-vim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'lewis6991/gitsigns.nvim'
  use { 'chentau/marks.nvim', lock = true }
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'neovim/nvim-lspconfig'
  use 'kosayoda/nvim-lightbulb'
  use 'nvim-lua/lsp-status.nvim'
  use 'folke/trouble.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'p00f/nvim-ts-rainbow'
  use { 'michaelb/sniprun', run = 'bash ./install.sh' }
  use 'windwp/nvim-spectre'
  use 'github/copilot.vim'

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
  use 'sirver/ultisnips'
  use 'honza/vim-snippets'
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use 'onsails/lspkind-nvim'

  use 'norcalli/nvim-colorizer.lua'
  use 'connorholyday/vim-snazzy'
  use 'folke/which-key.nvim'

  -- language specific
  use {"ellisonleao/glow.nvim", branch = 'main'} --markdown preview
  -- this one dont need update for now
  use { 'p00f/cphelper.nvim', lock = true }
end)

vim.opt.exrc = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.linebreak = true
vim.opt.sidescrolloff = 5
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.title = true
vim.opt.joinspaces = false
vim.opt.mouse = 'a'
vim.opt.laststatus = 3
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.conceallevel = 2
vim.opt.list = true
vim.opt.listchars = {
    tab = '→ ',
    nbsp = '␣',
    trail = '•',
    extends = '▶',
    precedes = '◀',
}
vim.opt.clipboard = vim.opt.clipboard + {'unnamed','unnamedplus'}

vim.opt.undofile = true
vim.opt.undodir=os.getenv( "HOME" ) ..'/.config/nvim/undodir'
vim.opt.scrolloff = 3
vim.opt.autoread = true
vim.opt.autowriteall = true
vim.opt.updatetime = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cindent = true
vim.opt.cinoptions = {'N-s', 'g0', 'j1', '(s', 'm1'}

-- Searching options
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.guicursor=[[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175]]
vim.opt.termguicolors = true
vim.g.firenvim_config = { localSettings = {['.*'] = {takeover= 'never', priority= 1 }}}

vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-l>', '<right>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-h>', '<left>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-j>', '<down>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-k>', '<up>', {noremap=true, silent=true})

vim.api.nvim_set_keymap('n', '<leader>d', '"_d', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'yA', ':%y<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'dA', 'gg"_dG', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('x', '<leader>d', '"_d', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'Zz', ':q<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<CR>', '10j', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '\\', '10k', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-c>', ':nohl<CR><C-L>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<S-l>', ':bn<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<S-h>', ':bp<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>q', ':w<CR>:bd<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'cp', ':let @+ = expand("%:p")<CR>', {noremap=true, silent=true})
--" Opens a new tab with the current buffer's path
--" Super useful when editing files in the same directory
vim.api.nvim_set_keymap('n', '<leader>e', ':e <C-r>=expand("%:p:h")<CR>/', {noremap=true, silent=true})

-- Move a line of text using ALT+[jk] or Command+[jk] on mac
vim.api.nvim_set_keymap('n', '∆', 'mz:m+<cr>`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '˚', 'mz:m-2<cr>`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '∆', ':m\'>+<cr>`<my`>mzgv`yo`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '˚', ':m\'<-2<cr>`>my`<mzgv`yo`z', {noremap=true, silent=true})
--" Pressing leader ss will toggle and untoggle spell checking
vim.api.nvim_set_keymap('n', '<leader>ss', ':setlocal spell!<CR>', {noremap=true, silent=true})

--" Visual mode pressing * or # searches for the current selection
--" Super useful! From an idea by Michael Naumann
vim.api.nvim_set_keymap('v', '*', '<cmd>lua VisualSelection("f")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '#', '<cmd>lua VisualSelection("b")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', 'R', '<cmd>lua VisualSelection("r")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('c', '<C-l>', '<right>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('c', '<C-h>', '<left>', {noremap=true, silent=true})

function VisualSelection(direction) 
  vim.cmd [[normal! vgv"ky]]
  local pattern = vim.fn.getreg('k')
  pattern = vim.fn.escape(pattern, "\\/.*'$^~[]")
  -- pattern = vim.fn.substitute(pattern, "2", "\\n", 'g')
  pattern = pattern:gsub("\n", "\\n")
  if direction == 'b' then
      vim.fn.feedkeys('?' .. pattern .. t"<CR>")
  elseif direction == 'r' then
      vim.fn.feedkeys(':' .. "%s" .. '/'.. pattern .. '/')
  elseif direction == 'f' then
      vim.fn.feedkeys('/' .. pattern .. t"<CR>")
  end
end

function StripTrailingWhitespaces()
  local save_state = vim.fn.winsaveview()
  vim.cmd[[keeppatterns %s/\s\+$//e]]
  vim.cmd[[keeppatterns %s/\n\{3,}/\r\r/e]]
  vim.fn.winrestview(save_state)
end

function CursorHoldWriteFile()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local mod = vim.api.nvim_buf_get_option(0, "modifiable")
  if mod and buf_name ~= "" then
    vim.cmd("update")
  end
end

vim.api.nvim_create_autocmd(
  {"BufWritePre","FileWritePre","FileAppendPre","FilterWritePre"},
  {pattern="*.cpp", callback = StripTrailingWhitespaces }
)
vim.api.nvim_create_autocmd({"BufEnter","FocusGained","InsertLeave"}, { command = "set relativenumber" })
vim.api.nvim_create_autocmd({"BufLeave","FocusLost","InsertEnter"}, { command = "set norelativenumber" })
vim.api.nvim_create_autocmd("CursorHold", { callback = CursorHoldWriteFile })
vim.cmd [[set errorformat^=%-GIn\ file\ included\ %.%#]]
vim.opt.guifont = "FiraCode Nerd Font Mono:h12"
--gui don't need set lang, terminal nvim need set lang to make the copy right
if vim.fn.has('gui_vimr') == 0 then
  vim.cmd [[language en_US]]
end
vim.cmd [[colo snazzy]]
-- vim.cmd [[colo desert]]
vim.cmd [[highlight CursorLine term=bold cterm=bold ctermbg=none  ctermfg=none gui=bold guibg=none]]
-- Treesitter
local treesitter = require('nvim-treesitter.configs')
treesitter.setup {
    ensure_installed = {'c', 'cpp', 'python', 'lua', 'javascript', 'html', 'css', 'vim'},
    highlight = { enable = true },
    indent = { enable = true },
    rainbow = { enable = true, extended_mode = true, },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 1

-- LSP

local nvim_lsp = require('lspconfig')

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 8,
      severity_limit = 'Error',
    },
    signs = false,
    update_in_insert = false,
  }
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  -- Workspace management
  buf_set_keymap('n', '<Leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  buf_set_keymap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>lf', '<cmd>Telescope lsp_code_actions<CR>', opts)
  buf_set_keymap('n', '<Leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<Leader>lw', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end


-- Completion
vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
vim.g.UltiSnipsRemoveSelectModeMappings = 0
vim.g.UltiSnipsSnippetDirectories = {os.getenv( "HOME" ) .. '/.config/coc/ultisnips/'}
local cmp = require'cmp'
cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              else
                  cmp.complete()
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
              elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                  vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
              else
                  fallback()
              end
          end,
          s = function(fallback)
              if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                  vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
              else
                  fallback()
              end
          end
      }),
      ["<S-Tab>"] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              else
                  cmp.complete()
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
              elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                  return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
              else
                  fallback()
              end
          end,
          s = function(fallback)
              if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                  return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
              else
                  fallback()
              end
          end
      }),
      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i', 'c'}),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i', 'c'}),
      ['<C-n>'] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                  vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                  fallback()
              end
          end
      }),
      ['<C-p>'] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                  vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                  fallback()
              end
          end
      }),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
      ['<Space>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
      ['<CR>'] = cmp.mapping({
          i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
          c = function(fallback)
            if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
                fallback()
            end
          end
      }),
  }),

  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
    { name = 'path'  },
    {name = 'buffer', keyword_length=5 },
    {name = 'calc'},
    -- {name = 'rg'},
    {name = 'nvim_lua'},
    {name = 'nvim_lsp_signature_help'},
  }
})
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "clangd", "pyright" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = lsp_on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
end

local lspkind = require('lspkind')
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}
cmp.setup {
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
}

-- gitsigns
require('gitsigns').setup()

-- telescope
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  defaults = {
    -- Default configuration for telescope goes here:
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '-u' -- thats the new thing
    },
	file_ignore_patterns = {
      'node_modules/', '.git/', '.vscode/', '.Library/', 
      '.composer/', '.m2/', '.oh%-my%-zsh/', '.cache/',
      '.npm/', '.cargo/' },
  },
	pickers = {
		find_files = {
			hidden = true
		}
	}
}
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', {noremap=true, silent=true})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- nvim tree
-- empty setup using defaults: add your own options
require'nvim-tree'.setup {
}
vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', {noremap=true, silent=true})
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`

 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

-- comment
require('Comment').setup {
}

-- sniprun
require('sniprun').setup {
	interpreter_options = {
        Cpp_original = {
            compiler = "g++-11"
            }
        },
  --# you can combo different display modes as desired
  display = {
    "TempFloatingWindow",      --# display results in a floating window
  },
}
vim.api.nvim_set_keymap('v', '<F5>', '<Plug>SnipRun', {silent = true})
vim.api.nvim_set_keymap('n', '<F6>', '<Plug>SnipRunOperator', {silent = true})
vim.api.nvim_set_keymap('n', '<F5>', '<Plug>SnipRun', {silent = true})

-- bufferline
require('bufferline').setup{
	options = {
		numbers = function(opts)
			return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
		end,
	}

}
vim.api.nvim_set_keymap('n', '<leader>b', ':BufferLinePick<CR>', {silent = true})

-- minimap
vim.cmd [[highlight VertSplit cterm=NONE]]

-- toggleterm
require("toggleterm").setup{
  open_mapping = [[<leader>n]],
  hide_numbers = false, -- hide the number column in toggleterm buffers
  start_in_insert = true,
  insert_mappings = false, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  shade_terminals = false,
  direction = 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}
local Terminal  = require('toggleterm.terminal').Terminal

local gccomplie = Terminal:new({
	count=3,
	close_on_exit=true,
})
function _gccomplie_toggle()
  vim.cmd[[w]]
  vim.cmd[[3TermExec cmd="g++-11 -std=c++17 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion -fsanitize=address -fsanitize=undefined -DLOCAL %:r.cpp -o %:r"]]
end

function _gccrun_toggle()
  vim.cmd[[3TermExec cmd="%:p:h/%:t:r"]]
end

vim.api.nvim_set_keymap("", "<F3>", "<cmd>lua _gccomplie_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("", "<F4>", "<cmd>lua _gccrun_toggle()<CR>", {noremap = true, silent = true})

local lazygit = Terminal:new({ cmd = "lazygit", count=5, hidden = true })
function _lazygit_toggle()
  lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

-- spectre
require('spectre').setup {
	replace_engine={
      ['sed']={
          cmd = "gsed",
          args = nil
      },
      options = {
        ['ignore-case'] = {
          value= "--ignore-case",
          icon="[I]",
          desc="ignore case"
        },
      }
  },
}
vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>lua require('spectre').open_file_search()<cr>", {noremap = true, silent = true})

-- nvim-hlslens
local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

-- nvim-scrollbar
require("scrollbar").setup{
	show=true,
	set_highlights=true,
	handle = {
		color = '#606361',
	},
    marks = {
        Search = { color = "#ff9e64" },
        Error = { color = '#f7768e' },
        Warn = { color = "#e0af68" },
        Info = { color = "#0db9d7" },
        Hint = { color = '#1abc9c' },
        Misc = { color = '#9d7cd8'},
    },
	handlers = {
		search = true
	}
}

-- colorizer
require'colorizer'.setup{}
vim.api.nvim_create_autocmd({"BufEnter"}, { command = "ColorizerAttachToBuffer" })

-- cphelper
vim.g.cphdir = t'/Users/ndz/Documents/code/github/algo/contests'
vim.g.cpp_compile_command = 'g++-11 -std=c++17 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion -fsanitize=address -fsanitize=undefined -DLOCAL solution.cpp -o cpp.out'
vim.api.nvim_set_keymap("n", "<leader>cr", "<cmd>CphReceive<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>ct", "<cmd>CphTest<cr>", {noremap = true, silent = true})

-- alpha dashboard
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
function _cd_cpdir()
  vim.cmd[[cd /Users/ndz/Documents/code/github/algo]]
  require'nvim-tree'.change_dir('/Users/ndz/Documents/code/github/algo')
  vim.cmd[[CphReceive]]
end

function _del_redofile()
  os.execute('rm -f ' .. os.getenv( "HOME" ) ..'/.config/nvim/undodir/*')
  print("done...")
end
dashboard.section.buttons.val = {
  dashboard.button( "e", "  > New file" , "<cmd>ene <CR>"),
  dashboard.button( "c", "  > Competitive", "<cmd>lua _cd_cpdir()<CR>"),
  dashboard.button( "u", "  > Update"   , "<cmd>PackerSync<CR>"),
  dashboard.button( "f", "  > Find Files" , "<cmd>Telescope find_files<cr>"),
  dashboard.button( "d", "﯊  > Del RedoFile", "<cmd>lua _del_redofile()<CR>"),
}
dashboard.section.header.val =
{
'███╗   ██╗██╗██╗   ██╗██╗   ██╗██╗███╗   ███╗',
'████╗  ██║██║██║   ██║██║   ██║██║████╗ ████║',
'██╔██╗ ██║██║██║   ██║██║   ██║██║██╔████╔██║',
'██║╚██╗██║██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
'██║ ╚████║██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
'╚═╝  ╚═══╝╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
}

local function footer()
  local plugins = #vim.tbl_keys(packer_plugins) --get packer_plugins plugins
  local v = vim.version()
  local datetime = os.date " %Y-%m-%d   %H:%M:%S"
  return string.format(" %d   v%d.%d.%d  %s", plugins, v.major, v.minor, v.patch, datetime)
end
dashboard.section.footer.val = footer()

alpha.setup(dashboard.opts)
vim.api.nvim_create_autocmd({"FileType"}, {pattern={"alpha"}, command = "setlocal nofoldenable" })
vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>Alpha<CR>', {noremap=true, silent=true})

-- lualine
require('lualine').setup{
	options = {
    theme = 'nightfly',
    globalstatus = true,
  },
  sections = { lualine_c = { "filename", "b:lsp_current_function" } }
}

-- nvim-autoapirs
local npairs = require('nvim-autopairs')
npairs.setup{
	map_cr=false,
	fast_wrap = {
		map = '´', --alt-e
	},
}
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"


-- copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-o>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap('i', '‘', '<Plug>(copilot-next)', {silent = true}) -- alt-]
vim.api.nvim_set_keymap('i', '“', '<Plug>(copilot-previous)', {silent = true}) --alt-[

--which key
require("which-key").setup {}

-- indent line
require("indent_blankline").setup {}
vim.g.indent_blankline_filetype_exclude = vim.list_extend(vim.g.indent_blankline_filetype_exclude,{"alpha", "CHADTree", "NvimTree"})

--chadtree
vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>CHADopen<cr>', {noremap=true, silent=true})

-- marks
require('marks').setup{}

-- trouble
require('trouble').setup{}
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>",
  {silent = true, noremap = true}
)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>",
  {silent = true, noremap = true}
)

-- nvim-lightbulb
vim.api.nvim_create_autocmd( "CursorHold", {
  callback = function()
    require'nvim-lightbulb'.update_lightbulb()
  end
})

-- lsp-status
require('lsp-status').config{}
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    require('lsp-status/current_function').update()
  end
})
