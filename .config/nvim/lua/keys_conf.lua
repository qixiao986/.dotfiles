require('utils_conf')

vim.g.mapleader = t'<Space>'
vim.g.maplocalleader = t'<Space>'

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
vim.api.nvim_set_keymap('n', '<C-\\>', ':vsp<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-_>', ':sp<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>q', ':bd!<CR>', {noremap=true, silent=true})
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

--" Visual mode pressing * or # searches for the current selection
--" Super useful! From an idea by Michael Naumann
vim.api.nvim_set_keymap('v', '*', '<cmd>lua VisualSelection("f")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', '#', '<cmd>lua VisualSelection("b")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('v', 'R', '<cmd>lua VisualSelection("r")<cr>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('c', '<C-l>', '<right>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('c', '<C-h>', '<left>', {noremap=true, silent=true})


