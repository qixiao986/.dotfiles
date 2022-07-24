local Hydra = require("hydra")

Hydra({
	name = "Change / Resize Window",
	mode = { "n" },
	body = "<c-w>",
  hint = [[
     _h_: left   _l_: right        _j_: down   _k_: up
     _H_: increase left   _L_: increase right   _J_: increase down   _K_: increase up
     ^ ^              _-_: split horizontal      ^ ^                 _|_: split virtical
     ^
     ^ ^                         _<Esc>_: exit
  ]],
  config = {
    hint = {
       position = 'bottom',
       border = 'rounded'
    },
    on_enter = function()
       vim.bo.modifiable = false
    end,
    on_exit = function()
    end
  },
	heads = {
		-- move between windows
		{ "h", "<C-w>h" },
		{ "j", "<C-w>j" },
		{ "k", "<C-w>k" },
		{ "l", "<C-w>l" },

    -- split windows
    { "-", ":sp<cr>"},
    { "|", ":vsp<cr>"},

		-- resizing window
		{ "H", "<C-w>3>" },
		{ "L", "<C-w>3<" },
		{ "K", "<C-w>2-" },
		{ "J", "<C-w>2+" },

		-- equalize window sizes
		{ "e", "<C-w>=" },

		{ "<Esc>", nil, { exit = true, nowait = true } },
	},
})
