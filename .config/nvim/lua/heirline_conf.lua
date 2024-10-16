local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = {
	red = utils.get_highlight("DiagnosticError").fg,
	green = utils.get_highlight("String").fg,
	blue = utils.get_highlight("Function").fg,
	gray = utils.get_highlight("NonText").fg,
	orange = utils.get_highlight("DiagnosticWarn").fg,
	purple = utils.get_highlight("Statement").fg,
	cyan = utils.get_highlight("Special").fg,
	diag = {
		warn = utils.get_highlight("DiagnosticWarn").fg,
		error = utils.get_highlight("DiagnosticError").fg,
		hint = utils.get_highlight("DiagnosticHint").fg,
		info = utils.get_highlight("DiagnosticInfo").fg,
	},
	git = {
		del = "#ff0000",
		add = "#00ff00",
		change = "#ffff00",
	},
}

local ViMode = {
	-- get vim current mode, this information will be required by the provider
	-- and the highlight functions, so we compute it only once per component
	-- evaluation and store it as a component attribute
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	-- Now we define some dictionaries to map the output of mode() to the
	-- corresponding string and color. We can put these into `static` to compute
	-- them at initialisation time.
	static = {
		mode_names = { -- change the strings if yow like it vvvvverbose!
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		},
		mode_colors = {
			n = colors.red,
			i = colors.green,
			v = colors.cyan,
			V = colors.cyan,
			["\22"] = colors.cyan,
			c = colors.orange,
			s = colors.purple,
			S = colors.purple,
			["\19"] = colors.purple,
			R = colors.orange,
			r = colors.orange,
			["!"] = colors.red,
			t = colors.red,
		},
	},
	-- We can now access the value of mode() that, by now, would have been
	-- computed by `init()` and use it to index our strings dictionary.
	-- note how `static` fields become just regular attributes once the
	-- component is instantiated.
	-- To be extra meticulous, we can also add some vim statusline syntax to
	-- control the padding and make sure our string is always at least 2
	-- characters long. Plus a nice Icon.
	provider = function(self)
		return " %2(" .. self.mode_names[self.mode] .. "%)"
	end,
	-- Same goes for the highlight. Now the foreground will change according to the current mode.
	hl = function(self)
		local mode = self.mode:sub(1, 1) -- get only the first mode character
		return { fg = self.mode_colors[mode], bold = true }
	end,
}

local FileName = {
	init = function(self)
		self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
		if self.lfilename == "" then
			self.lfilename = "[No Name]"
		end
	end,
	hl = { fg = utils.get_highlight("Directory").fg },

  on_click = {
    name = "heirline_filename",
    callback = function()
      vim.defer_fn(function()
        local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        vim.cmd("cd ".. dir)
      end, 100)
    end,
  },
  {
		provider = function(self)
			return self.lfilename
		end,
	}, 
  {
		provider = function(self)
			return vim.fn.pathshorten(self.lfilename)
		end,
  },
  flexible = 2,
}

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
  on_click = {
    name = "heirline_filename",
    callback = function()
      vim.defer_fn(function()
        local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        vim.cmd("cd ".. dir)
      end, 100)
    end,
  }
}
-- We can now define some children separately and add them later

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
			filename,
			extension,
			{ default = true }
		)
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

local FileFlags = {
	{
		provider = function()
			if vim.bo.modified then
				return "[+]"
			end
		end,
		hl = { fg = colors.green },
	},
	{
		provider = function()
			if not vim.bo.modifiable or vim.bo.readonly then
				return ""
			end
		end,
		hl = { fg = colors.orange },
	},
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
	hl = function()
		if vim.bo.modified then
			-- use `force` because we need to override the child's hl foreground
			return { fg = colors.cyan, bold = true, force = true }
		end
	end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(
	FileNameBlock,
	FileIcon,
	utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
	unpack(FileFlags), -- A small optimisation, since their parent does nothing
	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

local FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
  on_click = {
    name = "heirline_filetype",
    callback = function()
      vim.defer_fn(function()
        if string.upper(vim.bo.filetype) == "TEXT" then
          vim.cmd("set filetype=cpp")
        end
      end, 100)
    end,
  },
}

local FileEncoding = {
	provider = function()
		local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
		return enc ~= "utf-8" and enc:upper()
	end,
}

local FileFormat = {
	provider = function()
		local fmt = vim.bo.fileformat
		return fmt ~= "unix" and fmt:upper()
	end,
}

local FileSize = {
	provider = function()
		-- stackoverflow, compute human readable file size
		local suffix = { "b", "k", "M", "G", "T", "P", "E" }
		local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
		fsize = (fsize < 0 and 0) or fsize
		if fsize <= 0 then
			return "0" .. suffix[1]
		end
		local i = math.floor((math.log(fsize) / math.log(1024)))
		return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
	end,
}

local FileLastModified = {
	-- did you know? Vim is full of functions!
	provider = function()
		local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
		return (ftime > 0) and os.date("%c", ftime)
	end,
}

-- We're getting minimalists here!
local Ruler = {
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- %c = column number
	-- %P = percentage through file of displayed window
	provider = "%(%l/%L%):%c %P",
}

-- I take no credits for this! :lion:
local ScrollBar = {
	static = {
		sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
		-- Another variant, because the more choice the better.
		-- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
	},
	provider = function(self)
		local curr_line = vim.api.nvim_win_get_cursor(0)[1]
		local lines = vim.api.nvim_buf_line_count(0)
		local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
		return string.rep(self.sbar[i], 2)
	end,
	hl = { fg = colors.blue, bg = colors.bright_bg },
}

local LSPActive = {
	condition = conditions.lsp_attached,

  on_click = {
    name = "heirline_LSP",
    callback = function()
      vim.defer_fn(function()
        vim.cmd("LspInfo")
      end, 100)
    end,
  },
	-- You can keep it simple,
	-- provider = " [LSP]",

	-- Or complicate things a bit and get the servers names
	provider = function()
		local names = {}
		for i, server in pairs(vim.lsp.buf_get_clients(0)) do
			table.insert(names, server.name)
		end
		return " [" .. table.concat(names, " ") .. "]"
	end,
	hl = { fg = colors.green, bold = true },
}

-- I personally use it only to display progress messages!
-- See lsp-status/README.md for configuration options.

-- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
local LSPMessages = {
	provider = require("lsp-status").status,
	hl = { fg = colors.green },
}

-- Awesome plugin
-- Full nerd (with icon colors)!
local Navic = {
  condition = function() return require("nvim-navic").is_available() end,
  static = {
    -- create a type highlight map
    type_hl = {
        File = "Directory",
        Module = "@include",
        Namespace = "@namespace",
        Package = "@include",
        Class = "@structure",
        Method = "@method",
        Property = "@property",
        Field = "@field",
        Constructor = "@constructor",
        Enum = "@field",
        Interface = "@type",
        Function = "@function",
        Variable = "@variable",
        Constant = "@constant",
        String = "@string",
        Number = "@number",
        Boolean = "@boolean",
        Array = "@field",
        Object = "@type",
        Key = "@keyword",
        Null = "@comment",
        EnumMember = "@field",
        Struct = "@structure",
        Event = "@keyword",
        Operator = "@operator",
        TypeParameter = "@type",
    },
    -- bit operation dark magic, see below...
    enc = function(line, col, winnr)
        return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
    end,
    -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
    dec = function(c)
        local line = bit.rshift(c, 16)
        local col = bit.band(bit.rshift(c, 6), 1023)
        local winnr = bit.band(c,  63)
        return line, col, winnr
    end
  },
  init = function(self)
    local data = require("nvim-navic").get_data() or {}
    local children = {}
    -- create a child for each level
    for i, d in ipairs(data) do
        -- encode line and column numbers into a single integer
        local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
        local child = {
            {
                provider = d.icon,
                hl = self.type_hl[d.type],
            },
            {
                -- escape `%`s (elixir) and buggy default separators
                provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ''),
                -- highlight icon only or location name as well
                -- hl = self.type_hl[d.type],

                on_click = {
                    -- pass the encoded position through minwid
                    minwid = pos,
                    callback = function(_, minwid)
                        -- decode
                        local line, col, winnr = self.dec(minwid)
                        vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), {line, col})
                    end,
                    name = "heirline_navic",
                },
            },
        }
        -- add a separator only if needed
        if #data > 1 and i < #data then
            table.insert(child, {
                provider = " > ",
                hl = { fg = colors.bright_fg },
            })
        end
        table.insert(children, child)
    end
    -- instantiate the new child, overwriting the previous one
    self.child = self:new(children, 1)
  end,
  -- evaluate the children containing navic components
  provider = function(self)
    return self.child:eval()
  end,
  hl = { fg = colors.gray },
  update = 'CursorMoved'
}
--[[ local Navic = { flexible = 3, Navic, { provider = "" } } ]]

local Diagnostics = {

	condition = function(self)
    local bufnr = vim.api.nvim_get_current_buf()
    return #vim.diagnostic.get(self.bufnr or bufnr) > 0
  end,

	static = {
		error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
		warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
		info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
		hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
	},

	init = function(self)
    local bufnr = vim.api.nvim_get_current_buf()
		self.errors = #vim.diagnostic.get(self.bufnr or bufnr, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(self.bufnr or bufnr, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(self.bufnr or bufnr, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(self.bufnr or bufnr, { severity = vim.diagnostic.severity.INFO })
	end,
  on_click = {
    callback = function()
      require("trouble").toggle({ mode = "document_diagnostics" })
      -- or
      -- vim.diagnostic.setqflist()
    end,
    name = "heirline_diagnostics",
  },
	update = { "DiagnosticChanged", "BufEnter" },

	{
		provider = "![",
	},
	{
		provider = function(self)
			-- 0 is just another output, we can decide to print it or not!
			return self.errors > 0 and (self.error_icon .. self.errors .. " ")
		end,
		hl = { fg = colors.diag.error },
	},
	{
		provider = function(self)
			return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
		end,
		hl = { fg = colors.diag.warn },
	},
	{
		provider = function(self)
			return self.info > 0 and (self.info_icon .. self.info .. " ")
		end,
		hl = { fg = colors.diag.info },
	},
	{
		provider = function(self)
			return self.hints > 0 and (self.hint_icon .. self.hints)
		end,
		hl = { fg = colors.diag.hint },
	},
	{
		provider = "]",
	},
}

local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	hl = { fg = colors.orange },

	on_click = {
		name = "heirline_git",
		callback = function()
			vim.defer_fn(function() end, 100)
		end,
	},

	{ -- git branch name
		provider = function(self)
			return " " .. self.status_dict.head
		end,
		hl = { bold = true },
	},
	-- You could handle delimiters, icons and counts similar to Diagnostics
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = "(",
	},
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and ("+" .. count)
		end,
		hl = { fg = colors.git.add },
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and ("-" .. count)
		end,
		hl = { fg = colors.git.del },
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and ("~" .. count)
		end,
		hl = { fg = colors.git.change },
	},
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = ")",
	},
}

local HelpFileName = {
	condition = function()
		return vim.bo.filetype == "help"
	end,
	provider = function()
		local filename = vim.api.nvim_buf_get_name(0)
		return vim.fn.fnamemodify(filename, ":t")
	end,
	hl = { fg = colors.blue },
}

local PluginStatus = {
  condition = require("lazy.status").has_updates,
  provider = function()
    return require("lazy.status").updates()
  end,
  on_click = {
    name = "heirline_lazy",
    callback = function()
      vim.defer_fn(function()
        vim.cmd("Lazy update")
      end, 100)
    end,
  },
  hl = { fg = colors.red },
}

local MacroStatus = {
  condition = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
  provider = function()
    local mode = require("noice").api.status.mode.get()
    if mode then
      return string.match(mode, "^recording @.*") or ""
    end
    return ""
  end,
  hl = {fg = colors.purple},
}

local CmdStatus = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = "%3.5(%S%)",
  hl = {fg = colors.blue},
}

local MsgStatus = {
  condition = function() return package.loaded["noice"] and require("noice").api.status.message.has() end,
  provider = function()
    return require("noice").api.status.message.get()
  end,
  hl = {fg = colors.orange},
}

local WorkDir = {
    provider = function()
        local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
        local cwd = vim.fn.getcwd(0)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conditions.width_percent_below(#cwd, 0.25) then
            cwd = vim.fn.pathshorten(cwd)
        end
        local trail = cwd:sub(-1) == '/' and '' or "/"
        return icon .. cwd  .. trail
    end,
    hl = { fg = "yellow", bold = true },
}

local TerminalName = {
	-- we could add a condition to check that buftype == 'terminal'
	-- or we could do that later (see #conditional-statuslines below)
	provider = function()
		local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
		return " " .. tname
	end,
	hl = { fg = colors.blue, bold = true },
}

local Snippets = {
	-- check that we are in insert or select mode
	condition = function()
		return vim.tbl_contains({ "s", "i" }, vim.fn.mode())
	end,
	provider = function()
		local luasnip = require("luasnip")
		local forward = luasnip.jumpable(1) and "" or ""
		local backward = luasnip.jumpable(-1) and " " or ""
		return backward .. forward
	end,
	hl = { fg = "red", bold = true },
}

local Align = { provider = "%=" }
local Space = { provider = " " }

ViMode = utils.surround({ "", "" }, colors.gray, { ViMode, Snippets })

local DefaultStatusline = {
  ViMode,
  Space,
  CmdStatus,
  Space,
  MacroStatus,
  Space,
  FileNameBlock,
  Space,
  Git,
  Space,
  Diagnostics,
  Align,
  Navic,
  Align,
  WorkDir,
  Space,
  PluginStatus,
  Space,
  LSPActive,
  Space,
  FileType,
  Space,
  FileEncoding,
  Space,
  Ruler,
  Space,
  ScrollBar,
}

local InactiveStatusline = {
  condition = function()
    return not conditions.is_active()
  end,

  FileType,
  Space,
  CmdStatus,
  Space,
  MacroStatus,
  Space,
  FileNameBlock,
  Align,
  PluginStatus,
  Space,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,

  FileType,
  Space,
  CmdStatus,
  Space,
  MacroStatus,
  Space,
  HelpFileName,
  Align,
  PluginStatus,
  Space,
}

local TerminalStatusline = {

	condition = function()
		return conditions.buffer_matches({ buftype = { "terminal" } })
	end,

	hl = { bg = colors.dark_red },

	-- Quickly add a condition to the ViMode to only show it when buffer is active!
  {
    condition = conditions.is_active,
    ViMode,
    Space,
    CmdStatus,
    Space,
    MacroStatus,
    Space,
  },
	FileType,
	Space,
	TerminalName,
	Align,
}

local StatusLines = {

	hl = function()
		if conditions.is_active() then
			return {
				fg = utils.get_highlight("StatusLine").fg,
				bg = utils.get_highlight("StatusLine").bg,
			}
		else
			return {
				fg = utils.get_highlight("StatusLineNC").fg,
				bg = utils.get_highlight("StatusLineNC").bg,
			}
		end
	end,

	fallthrough = false,

	SpecialStatusline,
	TerminalStatusline,
	InactiveStatusline,
	DefaultStatusline,
}

--- bufferline
local TablineBufnr = {
	provider = function(self)
		return tostring(self.bufnr) .. ". "
	end,
	hl = "Comment",
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TablineFileName = {
	provider = function(self)
		-- self.filename will be defined later, just keep looking at the example!
		local filename = self.filename
		filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
		return filename
	end,
	hl = function(self)
		return { bold = self.is_active, italic = self.is_active, fg = self.is_active and "red" or "white" }
	end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
local TablineFileFlags = {
	{
		condition = function(self)
			return vim.api.nvim_buf_get_option(self.bufnr, "modified")
		end,
		provider = " ●",
		hl = { fg = "yellow" },
	},
	{
		condition = function(self)
			return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
				or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
		end,
		provider = function(self)
			if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
				return "  "
			else
				return ""
			end
		end,
		hl = { fg = "orange" },
	},
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
	end,
	hl = function(self)
		if self.is_active then
			return "TabLineSel"
			-- why not?
			-- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
			--     return { fg = "gray" }
		else
			return "TabLine"
		end
	end,
	on_click = {
		callback = function(_, minwid, _, button)
			if button == "m" then -- close on mouse middle click
				vim.schedule(function()
					vim.api.nvim_buf_delete(minwid, { force = false })
				end)
			else
				vim.api.nvim_win_set_buf(0, minwid)
			end
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_tabline_buffer_callback",
	},
	TablineBufnr,
	FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
	TablineFileName,
	TablineFileFlags,
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
	condition = function(self)
		return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
	end,
	{ provider = " " },
	{
		provider = "󱎘",
		hl = { fg = "gray" },
		on_click = {
			callback = function(_, minwid)
				vim.schedule(function()
					vim.api.nvim_buf_delete(minwid, { force = false })
					vim.cmd.redrawtabline()
				end)
			end,
			minwid = function(self)
				return self.bufnr
			end,
			name = "heirline_tabline_close_buffer_callback",
		},
	},
}

local TablinePicker = {
	condition = function(self)
		return self._show_picker
	end,
	init = function(self)
		local bufname = vim.api.nvim_buf_get_name(self.bufnr)
		bufname = vim.fn.fnamemodify(bufname, ":t")
		local label = bufname:sub(1, 1)
		local i = 2
		while self._picker_labels[label] do
			if i > #bufname then
				break
			end
			label = bufname:sub(i, i)
			i = i + 1
		end
		self._picker_labels[label] = self.bufnr
		self.label = label
	end,
	provider = function(self)
		return self.label
	end,
	hl = { fg = "red", bold = true },
}

-- The final touch!
local TablineBufferBlock = utils.surround({ "", "" }, function(self)
	if self.is_active then
		return utils.get_highlight("TabLineSel").bg
	else
		return utils.get_highlight("TabLine").bg
	end
end, {TablinePicker, TablineFileNameBlock, Diagnostics, TablineCloseButton })

-- and here we go
local BufferLine = utils.make_buflist(
	TablineBufferBlock,
	{ provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
	{ provider = "", hl = { fg = "gray" } } -- right trunctation, also optional (defaults to ...... yep, ">")
	-- by the way, open a lot of buffers and try clicking them ;)
)

vim.cmd('hi TabLineFill guibg=' .. utils.get_highlight("TabLineSel").bg)

vim.keymap.set("n", "<leader>b", function()
	local tabline = require("heirline").tabline
	local buflist = tabline._buflist[1]
	buflist._picker_labels = {}
	buflist._show_picker = true
	vim.cmd.redrawtabline()
	local char = vim.fn.getcharstr()
	local bufnr = buflist._picker_labels[char]
	if bufnr then
		vim.api.nvim_win_set_buf(0, bufnr)
	end
	buflist._show_picker = false
	vim.cmd.redrawtabline()
end)

local Tabpage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
	end,
	hl = function(self)
		if not self.is_active then
			return "TabLine"
		else
			return "TabLineSel"
		end
	end,
}

local TabpageClose = {
	provider = "%999X  %X",
	hl = "TabLine",
}

local TabPages = {
	-- only show this component if there's 2 or more tabpages
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{ provider = "%=" },
	utils.make_tablist(Tabpage),
	TabpageClose,
}

local TabLineOffset = {
	condition = function(self)
		local win = vim.api.nvim_tabpage_list_wins(0)[1]
		local bufnr = vim.api.nvim_win_get_buf(win)
		self.winid = win

		if vim.bo[bufnr].filetype == "NvimTree" then
			self.title = "NvimTree"
			return true
			-- elseif vim.bo[bufnr].filetype == "TagBar" then
			--     ...
		end
	end,

	provider = function(self)
		local title = self.title
		local width = vim.api.nvim_win_get_width(self.winid)
		local pad = math.ceil((width - #title) / 2)
		return string.rep(" ", pad) .. title .. string.rep(" ", pad)
	end,

	hl = function(self)
		if vim.api.nvim_get_current_win() == self.winid then
			return "TablineSel"
		else
			return "Tabline"
		end
	end,
}

local TabLine = { TabLineOffset, BufferLine, TabPages }
require("heirline").setup({
	statusline = StatusLines,
	tabline = TabLine,
})

-- Yep, with heirline we're driving manual!
vim.o.showtabline = 2
vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
