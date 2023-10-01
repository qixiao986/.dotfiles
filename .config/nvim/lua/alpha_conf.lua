local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

function _del_redofile()
  os.execute('rm -f ' .. os.getenv( "HOME" ) ..'/.config/nvim/undodir/*')
  print("done...")
end
dashboard.section.buttons.val = {
  dashboard.button( "e", "  > New file" , "<cmd>ene <CR>"),
  dashboard.button( "c", "  > Competitive", "<cmd>CompetiTest receive contest<CR>"),
  dashboard.button( "u", "  > Update"   , "<cmd>Lazy update<CR>"),
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
  local plugins = require("lazy").stats().count --get packer_plugins plugins
  local v = vim.version()
  local datetime = os.date " %Y-%m-%d   %H:%M:%S"
  return string.format(" %d   v%d.%d.%d  %s", plugins, v.major, v.minor, v.patch, datetime)
end
dashboard.section.footer.val = footer()

alpha.setup(dashboard.opts)
vim.api.nvim_create_autocmd({"FileType"}, {pattern={"alpha"}, command = "setlocal nofoldenable" })
vim.keymap.set('n', '<leader>a', '<cmd>Alpha<CR>')

