require('utils_conf')
require('lazy_conf')
require('opt_conf')
require('keys_conf')

-- Treesitter
local treesitter = require('nvim-treesitter.configs')
treesitter.setup {
  ensure_installed = {'c', 'cpp','regex','markdown_inline', 'java', 'python', 'markdown', 'bash', 'lua', 'javascript', 'html', 'css', 'vim'},
  highlight = { enable = true },
  indent = { enable = true },
  rainbow = { enable = true, extended_mode = true, },
  incremental_selection = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
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

-- mason
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls",},
}

-- LSP
local nvim_lsp = require('lspconfig')

-- lspsaga
require 'lspsaga'.setup {}
local signs = {
  Error = ' ',
  Warn = ' ',
  Info = ' ',
  Hint = 'ﴞ ',
}
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  virtual_text = {
    source = true,
  },
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
  require('nvim-navic').attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  -- Workspace management
  buf_set_keymap('n', '<Leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  buf_set_keymap('n', '<Leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '<Leader>lq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  buf_set_keymap("n", "<Leader>lr", "<cmd>Lspsaga rename<cr>", opts)
  buf_set_keymap("n", "<Leader>lc", "<cmd>CodeActionMenu<cr>", opts)
  buf_set_keymap("x", "gx", ":<c-u>CodeActionMenu<cr>", opts)
  buf_set_keymap("n", "K",  "<cmd>Lspsaga hover_doc<cr>", opts)
  buf_set_keymap("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
  buf_set_keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
  buf_set_keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
  vim.keymap.set({'n', 'v'}, '<Leader>lf', function()
    vim.lsp.buf.format { async = true }
  end, opts)

end

-- nvim-code-action-menu
vim.g.code_action_menu_show_details = true
vim.g.code_action_menu_show_diff = true

-- Completion
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local types = require("luasnip.util.types")
require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/coc/ultisnips"})
-- require("luasnip.loaders.from_snipmate").lazy_load()
-- require("luasnip.loaders.from_vscode").lazy_load({paths = "~/.config/coc/ultisnips"})
luasnip.config.setup{
  update_events = "TextChanged,TextChangedI",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { {"<--Choice Node", "Error"}},
      }
    }
  }
}
vim.keymap.set('i', '<C-s>', '<cmd>lua require("luasnip.extras.select_choice")()<cr>')

local cmp = require'cmp'
cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),

      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i', 'c'}),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i', 'c'}),
      ['<C-n>'] = cmp.mapping({
          c = function()
              if luasnip.choice_active() then
                  luasnip.change_choice(1)
              elseif cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                  vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
              end
          end,
          s = function()
              if luasnip.choice_active() then
                  luasnip.change_choice(1)
              elseif cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                  vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
              end
          end,
          i = function(fallback)
              if luasnip.choice_active() then
                  luasnip.change_choice(1)
              elseif cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                  fallback()
              end
          end
      }),
      ['<C-p>'] = cmp.mapping({
          c = function()
              if luasnip.choice_active() then
                  luasnip.change_choice(-1)
              elseif cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                  vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
              end
          end,
          s = function()
              if luasnip.choice_active() then
                  luasnip.change_choice(-1)
              elseif cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                  vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
              end
          end,
          i = function(fallback)
              if luasnip.choice_active() then
                  luasnip.change_choice(-1)
              elseif cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                  fallback()
              end
          end
      }),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
      ['<C-[>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
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
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'nvim_lsp' },
    -- { name = 'cmp_tabnine'},
    { name = 'path'  },
    { name = 'dictionary', keyword_length=2 },
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
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.offsetEncoding = "utf-8"
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "clangd", "pyright", "gopls", "lua_ls" }
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
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      before = function(entry, vim_item)
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          --[[ cmp_tabnine = "[TabNine]", ]]
          dictionary = "[dictionary]",
          nvim_lua = "[Lua]",
          latex_symbols = "[LaTeX]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end
    })
  },
}

-- cmp_dictionary
require("cmp_dictionary").setup{
  dic = {
    ["*"] = {
      "/usr/share/dict/words", 
      -- os.getenv("HOME") .. "/Documents/words.txt"
    },
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

-- neo-tree
vim.g.neo_tree_remove_legacy_commands = 1
-- require("neo-tree").setup{
--   default_component_configs = {
--     git_status = {
--       symbols = {
--         unstaged  = "ﱵ",
--       }
--     },
--   },
--   filesystem = {
--     filtered_items = {
--       hide_dotfiles = false,
--     },
--   },
-- }
-- vim.keymap.set('n', '<leader>t', '<cmd>Neotree reveal toggle<CR>')

-- comment
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

-- sniprun
-- require('sniprun').setup {
-- 	interpreter_options = {
--         Cpp_original = {
--             compiler = "g++-13"
--             }
--         },
--   --# you can combo different display modes as desired
--   display = {
--     "TempFloatingWindow",      --# display results in a floating window
--   },
-- }
-- vim.keymap.set('v', '<F5>', '<Plug>SnipRun')
-- vim.keymap.set('n', '<F6>', '<Plug>SnipRunOperator')
-- vim.keymap.set('n', '<F5>', '<Plug>SnipRun')

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
  vim.cmd[[3TermExec cmd="g++-13 -std=c++17 -O2 -Wall -Wextra -pedantic -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wshift-overflow=2 -Wduplicated-cond -Wcast-qual -Wcast-align -Wno-unused-result -Wno-sign-conversion  -DLOCAL %:r.cpp -o %:r"]]
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

-- commpetitest
require('competitest').setup {
  received_problems_path = "$(HOME)/Documents/code/github/algo/contests/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)",
  received_contests_directory = "$(HOME)/Documents/code/github/algo/contests/$(JUDGE)/$(CONTEST)",
  compile_command = {
    cpp = { exec = "g++", args = { "-std=c++17", "-O2","-Wall","-Wextra","-pedantic","-Wshadow","-Wformat=2","-Wfloat-equal","-Wconversion","-Wlogical-op","-Wshift-overflow=2","-Wduplicated-cond","-Wcast-qual","-Wcast-align","-Wno-unused-result","-Wno-sign-conversion","-DLOCAL", "$(FNAME)", "-o", "$(FNOEXT)" } },
  },
  runner_ui = {
    viewer = {
      width = 1,
      height = 1,
    },
  },
}
vim.keymap.set("n", "<leader>cr", "<cmd>CompetiTest receive contest<CR>")
vim.keymap.set("n", "<leader>ct", "<cmd>CompetiTest run<CR>")

-- alpha dashboard
require('alpha_conf')

-- nvim-navic
require('nvim-navic').setup{}


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
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- copilot
-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set("i", "<C-o>", 'copilot#Accept("<CR>")', {expr = true})
-- vim.keymap.set('i', '‘', '<Plug>(copilot-next)') -- alt-]
-- vim.keymap.set('i', '“', '<Plug>(copilot-previous)') --alt-[

--which key
require("which-key").setup {}

-- indent line
require("ibl").setup{
  exclude = {
    filetypes = {"alpha", "neo-tree"}
  }
}

-- marks
-- require('marks').setup{}

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
require('focus').setup{enable = false}

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

-- neoscroll
require('neoscroll').setup()

--dressing
require('dressing').setup{}

-- nvim-ufo
require('fold_conf')

-- nvim-surround
require('nvim-surround').setup{}

-- lsp_liness
require('lsp_lines').setup{}
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

-- rnvimr
vim.keymap.set("n", "<leader>v", "<cmd>RnvimrToggle<cr>")
vim.keymap.set("t", "<leader>v", "<C-\\><C-n>:RnvimrToggle<cr>")

-- heirline
require('heirline_conf')

-- noice
require("noice").setup({
  views = {
    split = {
      size = "40%",
    },
    messages = {
      view = "vsplit",
      enter = true,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    {
      view = "notify",
      filter = { event = "msg_showmode" },
    },
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },

})

-- oil.nvim
require("oil").setup{
  view_options = {
    show_hidden = true,
  }
}

-- dap
local dap = require('dap')
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/Users/ndz/.local/share/nvim/mason/bin/OpenDebugAD7',
}
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = '/Users/ndz/.local/share/nvim/mason/bin/codelldb',
    args = {"--port", "${port}"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
}

require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})
require("dapui").setup()
-- vim.keymap.set('n', '<leader>bt', require("dapui").toggle)
-- vim.keymap.set('n', '<F5>', require 'dap'.continue)
-- vim.keymap.set('n', '<F10>', require 'dap'.step_over)
-- vim.keymap.set('n', '<F11>', require 'dap'.step_into)
-- vim.keymap.set('n', '<F12>', require 'dap'.step_out)
-- vim.keymap.set('n', '<leader>bb', require 'dap'.toggle_breakpoint)
