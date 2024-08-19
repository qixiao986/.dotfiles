require('utils_conf')
require('hydra_conf')

vim.g.mapleader = t'<Space>'
vim.g.maplocalleader = t'<Space>'

vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('i', '<C-l>', '<right>')
vim.keymap.set('i', '<C-h>', '<left>')
vim.keymap.set('i', '<C-j>', '<down>')
vim.keymap.set('i', '<C-k>', '<up>')

vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('n', 'yA', '<cmd>%y<CR>')
vim.keymap.set('n', 'dA', 'gg"_dG')
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('x', '<leader>d', '"_d')
vim.keymap.set('n', 'Zz', '<cmd>q<CR>')
vim.keymap.set('n', '<C-c>', ClearNoiceAndHL)
vim.keymap.set('n', '<C-i>', InputQEvery3Seconds)
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<S-l>', '<cmd>bn<CR>')
vim.keymap.set('n', '<S-h>', '<cmd>bp<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>bd!<CR>')
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', 'cp', '<cmd>let @+ = expand("%:p")<CR>')
--" Opens a new tab with the current buffer's path
--" Super useful when editing files in the same directory
vim.keymap.set('n', '<leader>e', ':e <C-r>=expand("%:p:h")<CR>/')

-- Move a line of text using ALT+[jk] or Command+[jk] on mac
vim.keymap.set('n', '∆', 'mz:m+<cr>`z')
vim.keymap.set('n', '˚', 'mz:m-2<cr>`z')
vim.keymap.set('v', '∆', ':m\'>+<cr>`<my`>mzgv`yo`z')
vim.keymap.set('v', '˚', ':m\'<-2<cr>`>my`<mzgv`yo`z')

--" Visual mode pressing * or # searches for the current selection
--" Super useful! From an idea by Michael Naumann
vim.keymap.set('v', '*', function() VisualSelection('f') end)
vim.keymap.set('v', '#', function() VisualSelection('b') end)
vim.keymap.set('v', 'R', function() VisualSelection('r') end)
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')
vim.keymap.set('c', '<C-l>', '<right>')
vim.keymap.set('c', '<C-h>', '<left>')

-- reload config
local reload_config = function()
  vim.lsp.stop_client(vim.lsp.get_active_clients()) --without this lsp will muti attach
  vim.cmd [[source ~/.config/nvim/init.lua]]
end
vim.keymap.set('n', '<leader>r', reload_config)
