function t(str)
    -- Adjust boolean arguments as needed
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

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
  pre_hook = function(ctx)
    local U = require 'Comment.utils'

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require('ts_context_commentstring.utils').get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require('ts_context_commentstring.utils').get_visual_start_location()
    end

    return require('ts_context_commentstring.internal').calculate_commentstring {
      key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
      location = location,
    }
  end,
}

-- nvim-surround
require('nvim-surround').setup{}


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
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('n', 'yA', '<cmd>%y<CR>')
vim.keymap.set('n', 'dA', 'gg"_dG')
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('x', '<leader>d', '"_d')
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
