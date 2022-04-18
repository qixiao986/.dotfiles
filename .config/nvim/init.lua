-- Concise way to escape termcodes
local function t(str)
    -- Adjust boolean arguments as needed
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.g.mapleader = t'<Space>'
vim.g.maplocalleader = t'<Space>'
-- vim.g.python3_host_prog = '/usr/local/bin/python'

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
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'neovim/nvim-lspconfig'
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
  -- this one dont need update for now
  use { 'p00f/cphelper.nvim' }
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

--vim.opt.foldmethod = 'syntax'
-- update gutters 200 ms
vim.opt.updatetime = 200

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cindent = true
vim.opt.cinoptions = {'n-s', 'g0', 'j1', '(s', 'm1'}

-- searching options
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.guicursor=[[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-cursor/lcursor,sm:block-blinkwait175-blinkoff150-blinkon175]]
vim.opt.termguicolors = true

vim.g.fzf_preview_window = {'right:50%', 'ctrl-/'}

vim.g.firenvim_config = { localsettings = {['.*'] = {takeover= 'never', priority= 1 }}}

vim.api.nvim_set_keymap('i', 'jk', '<esc>:w<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<c-l>', '<right>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<c-h>', '<left>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<c-j>', '<down>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('i', '<c-k>', '<up>', {noremap=true, silent=true})

vim.api.nvim_set_keymap('n', '<leader>d', '"_d', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>x', '"_x', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'ya', ':%y<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'da', 'gg"_dg', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'y', 'y$', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'j', 'mzj`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('x', '<leader>d', '"_d', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'zz', ':q<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<cr>', '10j', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '\\', '10k', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<c-l>', ':nohl<cr><c-l>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<s-l>', ':bn<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<s-h>', ':bp<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>q', ':w<cr>:bd<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>w', ':w<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'cp', ':let @+ = expand("%:p")<cr>', {noremap=true, silent=true})
--" opens a new tab with the current buffer's path
--" super useful when editing files in the same directory
vim.api.nvim_set_keymap('n', '<leader>e', ':e <c-r>=expand("%:p:h")<cr>/', {noremap=true, silent=true})

-- move a line of text using alt+[jk] or command+[jk] on mac
vim.api.nvim_set_keymap('n', '∆', 'mz:m+<cr>`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '˚', 'mz:m-2<cr>`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '∆', ':m\'>+<cr>`<my`>mzgv`yo`z', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '˚', ':m\'<-2<cr>`>my`<mzgv`yo`z', {noremap=true, silent=true})
--" pressing leader ss will toggle and untoggle spell checking
vim.api.nvim_set_keymap('', '<leader>ss', ':setlocal spell!<cr>', {noremap=true, silent=true})

--" visual mode pressing * or # searches for the current selection
--" super useful! from an idea by michael naumann
vim.api.nvim_set_keymap('v', '*', '<cmd>lua visualselection("f")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '#', '<cmd>lua visualselection("b")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', 'r', '<cmd>lua visualselection("r")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('t', '<esc>', '<c-\\><c-n>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('t', '<leader>v', '<c-w>"*', {noremap=true, silent=true})
vim.api.nvim_set_keymap('c', '<c-l>', '<right>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('c', '<c-h>', '<left>', {noremap=true, silent=true})

function visualselection(direction) 
  vim.cmd [[normal! vgv"ky]]
  local pattern = vim.fn.getreg('k')
  pattern = vim.fn.escape(pattern, "\\/.*'$^~[]")
  -- pattern = vim.fn.substitute(pattern, "2", "\\n", 'g')
  pattern = pattern:gsub("\n", "\\n")
  if direction == 'b' then
      vim.fn.feedkeys('?' .. pattern .. t"<cr>")
  elseif direction == 'r' then
      vim.fn.feedkeys(':' .. "%s" .. '/'.. pattern .. '/')
  elseif direction == 'f' then
      vim.fn.feedkeys('/' .. pattern .. t"<cr>")
  end
end

function striptrailingwhitespaces()
  local save_state = vim.fn.winsaveview()
  vim.cmd[[keeppatterns %s/\s\+$//e]]
  vim.cmd[[keeppatterns %s/\n\{3,}/\r\r/e]]
  vim.fn.winrestview(save_state)
end

vim.api.nvim_create_autocmd(
  {"bufwritepre","filewritepre","fileappendpre","filterwritepre"},
  {pattern="*.cpp", callback = striptrailingwhitespaces }
)
vim.api.nvim_create_autocmd({"bufenter","focusgained","insertleave"}, { command = "set relativenumber" })
vim.api.nvim_create_autocmd({"bufleave","focuslost","insertenter"}, { command = "set norelativenumber" })
vim.api.nvim_create_autocmd("cursorhold", { command = "update" })
vim.cmd [[set errorformat^=%-gin\ file\ included\ %.%#]]
vim.cmd [[set guifont=firacode\ nerd\ font\ mono:h12]]
--gui don't need set lang, terminal nvim need set lang to make the copy right
if vim.fn.has('gui_vimr') == 0 then
  vim.cmd [[language en_us]]
end
vim.cmd [[colo snazzy]]
-- vim.cmd [[colo desert]]
vim.cmd [[highlight cursorline term=bold cterm=bold ctermbg=none  ctermfg=none gui=bold guibg=none]]
-- treesitter
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

-- lsp

local nvim_lsp = require('lspconfig')

vim.lsp.handlers["textdocument/publishdiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 8,
      severity_limit = 'error',
    },
    signs = false,
    update_in_insert = false,
  }
)

-- use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- mappings.
  local opts = { noremap=true, silent=true }

  -- see `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  buf_set_keymap('n', 'k', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)

  -- workspace management
  buf_set_keymap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
  buf_set_keymap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
  buf_set_keymap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)

  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
  buf_set_keymap('n', '<leader>lw', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
end


-- completion
vim.g.ultisnipsexpandtrigger = '<plug>(ultisnips_expand)'
vim.g.ultisnipsjumpforwardtrigger = '<plug>(ultisnips_jump_forward)'
vim.g.ultisnipsjumpbackwardtrigger = '<plug>(ultisnips_jump_backward)'
vim.g.ultisnipslistsnippets = '<c-x><c-s>'
vim.g.ultisnipsremoveselectmodemappings = 0
vim.g.ultisnipssnippetdirectories = {os.getenv( "HOME" ) .. '/.config/coc/ultisnips/'}
local cmp = require'cmp'
cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  snippet = {
    -- required - you must specify a snippet engine
    expand = function(args)
      vim.fn["ultisnips#anon"](args.body) -- for `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<tab>"] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.selectbehavior.insert })
              else
                  cmp.complete()
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.selectbehavior.insert })
              elseif vim.fn["ultisnips#canjumpforwards"]() == 1 then
                  vim.api.nvim_feedkeys(t("<plug>(ultisnips_jump_forward)"), 'm', true)
              else
                  fallback()
              end
          end,
          s = function(fallback)
              if vim.fn["ultisnips#canjumpforwards"]() == 1 then
                  vim.api.nvim_feedkeys(t("<plug>(ultisnips_jump_forward)"), 'm', true)
              else
                  fallback()
              end
          end
      }),
      ["<s-tab>"] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.selectbehavior.insert })
              else
                  cmp.complete()
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.selectbehavior.insert })
              elseif vim.fn["ultisnips#canjumpbackwards"]() == 1 then
                  return vim.api.nvim_feedkeys( t("<plug>(ultisnips_jump_backward)"), 'm', true)
              else
                  fallback()
              end
          end,
          s = function(fallback)
              if vim.fn["ultisnips#canjumpbackwards"]() == 1 then
                  return vim.api.nvim_feedkeys( t("<plug>(ultisnips_jump_backward)"), 'm', true)
              else
                  fallback()
              end
          end
      }),
      -- ['<down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.selectbehavior.select }), {'i', 'c'}),
      -- ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.selectbehavior.select }), {'i', 'c'}),
      ['<c-n>'] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.selectbehavior.select })
              else
                  vim.api.nvim_feedkeys(t('<down>'), 'n', true)
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.selectbehavior.select })
              else
                  fallback()
              end
          end
      }),
      ['<c-p>'] = cmp.mapping({
          c = function()
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.selectbehavior.select })
              else
                  vim.api.nvim_feedkeys(t('<up>'), 'n', true)
              end
          end,
          i = function(fallback)
              if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.selectbehavior.select })
              else
                  fallback()
              end
          end
      }),
      ['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
      ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
      -- ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
      ['<space>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
      ['<cr>'] = cmp.mapping({
          -- i = cmp.mapping.confirm({ behavior = cmp.confirmbehavior.replace, select = false }),
          c = function(fallback)
            if cmp.visible() then
                cmp.confirm({ behavior = cmp.confirmbehavior.replace, select = false })
            else
                fallback()
            end
          end
      }),
  }),

  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- for ultisnips users.
    { name = 'path'  },
    {name = 'buffer', keyword_length=5 },
    {name = 'calc'},
    -- {name = 'rg'},
    {name = 'nvim_lua'},
    {name = 'nvim_lsp_signature_help'},
  }
})
-- set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- you can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})
-- use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- use a loop to conveniently call 'setup' on multiple servers and
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
  text = "",
  method = "",
  -- function = "",
  constructor = "",
  field = "",
  variable = "",
  class = "ﴯ",
  interface = "",
  module = "",
  property = "ﰠ",
  unit = "",
  value = "",
  enum = "",
  keyword = "",
  snippet = "",
  color = "",
  file = "",
  reference = "",
  folder = "",
  enummember = "",
  constant = "",
  struct = "",
  event = "",
  operator = "",
  typeparameter = ""
}
cmp.setup {
  formatting = {
    format = function(entry, vim_item)
      -- kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- this concatonates the icons with the name of the item kind
      -- source
      vim_item.menu = ({
        buffer = "[buffer]",
        nvim_lsp = "[lsp]",
        luasnip = "[luasnip]",
        nvim_lua = "[lua]",
        latex_symbols = "[latex]",
      })[entry.source.name]
      return vim_item
    end
  },
}

-- gitsigns
require('gitsigns').setup()

-- telescope
-- you dont need to set any of these options. these are the default ones. only
-- the loading is important
require('telescope').setup {
  defaults = {
    -- default configuration for telescope goes here:
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
      'node_modules/', '.git/', '.vscode/', '.library/', 
      '.composer/', '.m2/', '.oh%-my%-zsh/', '.cache/',
      '.npm/', '.cargo/' },
  },
	pickers = {
		find_files = {
			hidden = true
		}
	}
}
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>telescope find_files<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>telescope live_grep<cr>', {noremap=true, silent=true})
-- to get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- nvim tree
-- empty setup using defaults: add your own options
require'nvim-tree'.setup {
}
vim.api.nvim_set_keymap('n', '<leader>t', ':nvimtreetoggle<cr>', {noremap=true, silent=true})
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- devicon will be appended to `name`

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
    -- "Classic",                    --# display results in the command-line  area
    -- "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)

    -- "VirtualTextErr",          --# display error results as virtual text
    "TempFloatingWindow",      --# display results in a floating window
    -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText__
    -- "Terminal",                --# display results in a vertical split
    -- "TerminalWithCode",        --# display results and code history in a vertical split
    -- "NvimNotify",              --# display with the nvim-notify plugin
    -- "Api"                      --# return output to a programming interface
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
-- vim.g.minimap_auto_start = 1
-- vim.g.mminimap_auto_start_win_enter = 0

--floaterm
-- vim.api.nvim_set_keymap('', '<F3>', ':<C-U>w<CR>:FloatermNew --autoclose=1 g++-10 -std=c++17 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion -fsanitize=address -fsanitize=undefined -DLOCAL %:r.cpp -o %:r<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('', '<F2>', ':<C-U>w<CR>:FloatermNew --autoclose=1 g++-11 -std=c++17 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion -fsanitize=address -fsanitize=undefined -idirafter /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include -idirafter /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -DLOCAL %:r.cpp -o %:r<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('', '<F4>', ':<C-U>FloatermNew --autoclose=0 %:p:h/%:t:r<CR>', {noremap=true, silent=true} )
-- vim.api.nvim_set_keymap('n', '<leader>N', ':FloatermNew<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('n', '<leader>n', ':FloatermToggle<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('n', '<F7>', ':FloatermPrev<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('n', '<F8>', ':FloatermNext<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('t', '<F7>', '<C-\\><C-n>:FloatermPrev<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('t', '<leader>n', '<C-\\><C-n>:FloatermToggle<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('t', '<leader>N', '<C-\\><C-n>:FloatermNew<CR>', {noremap=true, silent=true})
-- vim.api.nvim_set_keymap('t', '<F8>', '<C-\\><C-n>:FloatermNext<CR>', {noremap=true, silent=true})

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
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved',
    -- width = 100,
    -- height = 50,
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
  -- gccomplie:toggle()
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
  dashboard.button( "u", "  > Update"   , "<cmd>PlugUpdate<CR>"),
  dashboard.button( "f", "  > Find Files" , "<cmd>Telescope find_files<cr>"),
  dashboard.button( "d", "﯊  > Del RedoFile", "<cmd>lua _del_redofile()<CR>"),
}
dashboard.section.header.val =
-- {
-- '  888b    888 8888888 888     888 888     888 8888888 888b     d888',
-- '  8888b   888   888   888     888 888     888   888   8888b   d8888',
-- '  88888b  888   888   888     888 888     888   888   88888b.d88888',
-- '  888Y88b 888   888   888     888 Y88b   d88P   888   888Y88888P888',
-- '  888 Y88b888   888   888     888  Y88b d88P    888   888 Y888P 888',
-- '  888  Y88888   888   888     888   Y88o88P     888   888  Y8P  888',
-- '  888   Y8888   888   Y88b. .d88P    Y888P      888   888   "   888',
-- '  888    Y888 8888888  "Y88888P"      Y8P     8888888 888       888',
-- }
{
'███╗   ██╗██╗██╗   ██╗██╗   ██╗██╗███╗   ███╗',
'████╗  ██║██║██║   ██║██║   ██║██║████╗ ████║',
'██╔██╗ ██║██║██║   ██║██║   ██║██║██╔████╔██║',
'██║╚██╗██║██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
'██║ ╚████║██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
'╚═╝  ╚═══╝╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
}

local function footer()
  local plugins = #vim.tbl_keys(packer_plugins) --get vim-plug plugins
  local v = vim.version()
  local datetime = os.date " %Y-%m-%d   %H:%M:%S"
  return string.format(" %d   v%d.%d.%d  %s", plugins, v.major, v.minor, v.patch, datetime)
end
dashboard.section.footer.val = footer()

alpha.setup(dashboard.opts)
vim.api.nvim_create_autocmd({"FileType"}, {pattern={"alpha"}, command = "setlocal nofoldenable" })

-- lualine
require('lualine').setup{
	options = { 
    theme = 'nightfly', 
    globalstatus = true,
  }
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

