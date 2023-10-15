local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.buttons.val = {
  dashboard.button( "e", "  > New file" , "<cmd>ene <CR>"),
  dashboard.button( "c", "  > Competitive", "<cmd>CompetiTest receive contest<CR>"),
  dashboard.button( "u", "  > Update"   , "<cmd>Lazy update<CR>"),
  dashboard.button( "r", "󱫒  > Recent Files"   , "<cmd>Telescope oldfiles<CR>"),
  dashboard.button( "d", "  > Del RedoFile", "<cmd>Oil " .. os.getenv( "HOME" ) ..'/.config/nvim/undodir/' .. "<CR>"),
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

