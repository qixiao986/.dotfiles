require('utils_conf')

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

  'ggandor/leap.nvim',
  'kevinhwang91/nvim-hlslens',
  "gbprod/cutlass.nvim",
  -- editor plugins
  'numtostr/comment.nvim',
  'kylechui/nvim-surround',
})


-- leap
require('leap').set_default_keymaps()

-- hlslens
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


-- comment
require('Comment').setup {
  -- pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

-- nvim-surround
require('nvim-surround').setup{}

-- cutlass
require('cutlass').setup{
  cut_key='x',
}

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true

vim.opt.clipboard:append('unnamed,unnamedplus')

vim.opt.undofile = true
vim.opt.undodir=os.getenv( "HOME" ) ..'/.config/nvim/undodir'

vim.g.mapleader = t'<Space>'
vim.g.maplocalleader = t'<Space>'
vim.keymap.set('n', 'yA', '<cmd>%y<CR>')
vim.keymap.set('n', 'dA', 'gg"_dG')
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', 'Zz', '<cmd>q<CR>')
vim.keymap.set('n', '<C-c>', '<cmd>nohl<CR><C-L>')
vim.keymap.set('n', 'cp', '<cmd>let @+ = expand("%:p")<CR>')

-- Move a line of text using ALT+[jk] or Command+[jk] on mac
vim.keymap.set('n', '<C-j>', 'mz:m+<cr>`z')
vim.keymap.set('n', '<C-k>', 'mz:m-2<cr>`z')
vim.keymap.set('v', '<C-j>', ':m\'>+<cr>`<my`>mzgv`yo`z')
vim.keymap.set('v', '<C-k>', ':m\'<-2<cr>`>my`<mzgv`yo`z')


--" Visual mode pressing * or # searches for the current selection
--" Super useful! From an idea by Michael Naumann
vim.keymap.set('v', '*', function() VisualSelection('f') end)
vim.keymap.set('v', '#', function() VisualSelection('b') end)
vim.keymap.set('v', 'R', function() VisualSelection('r') end)

