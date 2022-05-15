require('utils_conf')
require('packer_conf')
require('opt_conf')
require('keys_conf')

-- Treesitter
local treesitter = require('nvim-treesitter.configs')
treesitter.setup {
  ensure_installed = {'c', 'cpp', 'python', 'lua', 'javascript', 'html', 'css', 'vim'},
  highlight = { enable = true },
  indent = { enable = true },
  rainbow = { enable = true, extended_mode = true, },
  incremental_selection = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "°", --<alt-*>
        goto_previous_usage = "‹", --<alt-#>
      },
    },
  },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 1

-- treesitter-context
require'treesitter-context'.setup{}

-- LSP
local nvim_lsp = require('lspconfig')
-- lspsaga
require 'lspsaga'.setup {}

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
  -- buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  -- Workspace management
  buf_set_keymap('n', '<Leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  -- buf_set_keymap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<Leader>lc', '<cmd>Telescope lsp_code_actions<CR>', opts)
  buf_set_keymap('n', '<Leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>lq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<Leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  buf_set_keymap("n", "<Leader>lr", "<cmd>Lspsaga rename<cr>", {silent = true, noremap = true})
  buf_set_keymap("n", "<Leader>lc", "<cmd>CodeActionMenu<cr>", {silent = true, noremap = true})
  buf_set_keymap("x", "gx", ":<c-u>CodeActionMenu<cr>", {silent = true, noremap = true})
  buf_set_keymap("n", "K",  "<cmd>Lspsaga hover_doc<cr>", {silent = true, noremap = true})
  buf_set_keymap("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", {silent = true, noremap = true})
  buf_set_keymap("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", {silent = true, noremap = true})
  buf_set_keymap("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", {silent = true, noremap = true})
  buf_set_keymap("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
  buf_set_keymap("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})

end


-- nvim-code-action-menu
vim.g.code_action_menu_show_details = true
vim.g.code_action_menu_show_diff = true

-- Completion
vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
vim.g.UltiSnipsRemoveSelectModeMappings = 0
vim.g.UltiSnipsSnippetDirectories = {os.getenv( "HOME" ) .. '/.config/coc/ultisnips/', os.getenv( "HOME" ) .. '/.local/share/nvim/site/pack/packer/start/vim-snippets/UltiSnips/'}
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
      ['<C-Enter>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
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
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- nvim tree
-- empty setup using defaults: add your own options
require'nvim-tree'.setup {
}
vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<CR>')
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
vim.keymap.set('v', '<F5>', '<Plug>SnipRun')
vim.keymap.set('n', '<F6>', '<Plug>SnipRunOperator')
vim.keymap.set('n', '<F5>', '<Plug>SnipRun')

-- nvim-cokeline
require('cokeline_conf')

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
})
function _gccomplie_toggle()
  vim.cmd[[w]]
  vim.cmd[[3TermExec cmd="g++-11 -std=c++17 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion -fsanitize=address -fsanitize=undefined -DLOCAL %:r.cpp -o %:r"]]
end

function _gccrun_toggle()
  vim.cmd[[3TermExec cmd="%:p:h/%:t:r"]]
end

local lazygit = Terminal:new({ cmd = "lazygit", count=5, hidden = true })
function _lazygit_toggle()
  lazygit:toggle()
end
vim.keymap.set("n", "<F2>", _lazygit_toggle)

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
vim.keymap.set("n", "<leader>cr", "<cmd>CphReceive<cr>")
vim.keymap.set("n", "<leader>ct", "<cmd>CphTest<cr>")

-- alpha dashboard
require('alpha_conf')

-- nvim-gps
local gps = require('nvim-gps')
gps.setup{}


-- heirline
require('heirline_conf')

-- nvim-autoapirs
local npairs = require('nvim-autopairs')
npairs.setup{
	map_cr=true,
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
vim.keymap.set("i", "<C-o>", 'copilot#Accept("<CR>")', {expr = true})
vim.keymap.set('i', '‘', '<Plug>(copilot-next)') -- alt-]
vim.keymap.set('i', '“', '<Plug>(copilot-previous)') --alt-[

--which key
require("which-key").setup {}

-- indent line
require("indent_blankline").setup {}
vim.g.indent_blankline_filetype_exclude = vim.list_extend(vim.g.indent_blankline_filetype_exclude,{"alpha", "CHADTree", "NvimTree"})

--chadtree
vim.keymap.set('n', '<leader>v', '<cmd>CHADopen<cr>')

-- marks
require('marks').setup{}

-- trouble
require('trouble').setup{}
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>")
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>")

-- nvim-lightbulb
vim.api.nvim_create_autocmd( "CursorHold", {
  callback = function()
    require'nvim-lightbulb'.update_lightbulb()
  end
})

-- lsp-status
require('lsp-status').config{}


-- symbols-outline
vim.keymap.set("n", "<leader>s", "<cmd>SymbolsOutline<cr>")
vim.g.symbols_outline = {
  auto_preview = false,
}

-- focus
require('focus').setup{}

-- zen-mode
require('zen-mode').setup{}
vim.keymap.set("n", "<leader>z", require('zen-mode').toggle)

-- twilight
require('twilight').setup{}

-- leap
require('leap').set_default_keymaps()

-- possession
require('possession').setup{
  commands = {
    save = 'SSave',
    load = 'SLoad',
    delete = 'SDelete',
    list = 'SList',
  }
}
require('telescope').load_extension('possession')

-- toggletasks
require('toggletasks').setup{
  scan = {
    dirs = {
      os.getenv('HOME') .. '/.config/nvim/',
    },
  },
}
require('telescope').load_extension('toggletasks')
vim.keymap.set("n", "<F3>", require('telescope').extensions.toggletasks.spawn, {desc = 'toggletasks: spawn'})
vim.keymap.set("n", "<F4>", require('telescope').extensions.toggletasks.select, {desc = 'toggletasks: select'})

-- iswap
require('iswap').setup{
  autoswap = true,
}
vim.keymap.set("n", "<leader>h", "<cmd>ISwap<cr>")

-- numb
require('numb').setup{}

-- null-ls
require("null-ls_conf")
