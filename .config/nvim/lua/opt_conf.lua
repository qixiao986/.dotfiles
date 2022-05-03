require('utils_conf')

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
vim.opt.clipboard:append('unnamed,unnamedplus')

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

vim.opt.errorformat:prepend('%-GIn file included %.%#')
vim.opt.guifont = "FiraCode Nerd Font Mono:h12"
--gui don't need set lang, terminal nvim need set lang to make the copy right
if vim.fn.has('gui_vimr') == 0 then
  vim.cmd [[language en_US]]
end
vim.cmd [[colo snazzy]]
-- vim.cmd [[colo desert]]
vim.cmd [[highlight CursorLine term=bold cterm=bold ctermbg=none  ctermfg=none gui=bold guibg=none]]

-- Searching options
vim.opt.path:append('.,**')
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.guicursor=[[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175]]
vim.opt.termguicolors = true
vim.g.firenvim_config = { localSettings = {['.*'] = {takeover= 'never', priority= 1 }}}

vim.api.nvim_create_autocmd(
  {"BufWritePre","FileWritePre","FileAppendPre","FilterWritePre"},
  {pattern="*.cpp", callback = StripTrailingWhitespaces }
)
vim.api.nvim_create_autocmd({"BufEnter","FocusGained","InsertLeave"}, { command = "set relativenumber" })
vim.api.nvim_create_autocmd({"BufLeave","FocusLost","InsertEnter"}, { command = "set norelativenumber" })
vim.api.nvim_create_autocmd("CursorHold", { callback = CursorHoldWriteFile })

