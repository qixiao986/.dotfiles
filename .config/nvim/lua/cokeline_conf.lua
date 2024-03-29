local get_hex = require('cokeline.hlgroups').get_hl_attr
local mappings = require('cokeline.mappings')

local comments_fg = get_hex('Comment', 'fg')
local errors_fg = get_hex('DiagnosticError', 'fg')
local warnings_fg = get_hex('DiagnosticWarn', 'fg')

local normal_bg = get_hex('Normal', 'bg')
vim.cmd('hi TabLineFill guibg=' .. normal_bg)

local red = vim.g.terminal_color_1
local yellow = vim.g.terminal_color_3

local components = {
  space = {
    text = ' ',
    bg = get_hex('Normal', 'bg'),
    truncation = { priority = 1 }
  },

  two_spaces = {
    text = '  ',
    truncation = { priority = 1 },
  },

  separator_left = {
    text = '',
    fg = get_hex('ColorColumn', 'bg'),
    bg = get_hex('Normal', 'bg'),
  },

  separator_right = {
    text = '',
    fg = get_hex('ColorColumn', 'bg'),
    bg = get_hex('Normal', 'bg'),
  },

  devicon = {
    text = function(buffer)
      return
        (mappings.is_picking_focus() or mappings.is_picking_close())
          and buffer.pick_letter .. ' '
           or buffer.devicon.icon
    end,
    fg = function(buffer)
      return
        (mappings.is_picking_focus() and yellow)
        or (mappings.is_picking_close() and red)
        or buffer.devicon.color
    end,
    style = function(_)
      return
        (mappings.is_picking_focus() or mappings.is_picking_close())
        and 'italic,bold'
         or nil
    end,
    truncation = { priority = 1 }
  },

  index = {
    text = function(buffer)
      return buffer.index .. ': '
    end,
    truncation = { priority = 1 }
  },

  unique_prefix = {
    text = function(buffer)
      return buffer.unique_prefix
    end,
    style = function(buffer)
      return
        ((buffer.is_focused and buffer.diagnostics.errors ~= 0)
          and 'bold,underline')
        or (buffer.is_focused and 'bold')
        or (buffer.diagnostics.errors ~= 0 and 'underline')
        or nil
    end,
    truncation = {
      priority = 3,
      direction = 'left',
    },
  },

  filename = {
    text = function(buffer)
      return buffer.filename
    end,
    style = function(buffer)
      return
        ((buffer.is_focused and buffer.diagnostics.errors ~= 0)
          and 'bold,underline')
        or (buffer.is_focused and 'bold')
        or (buffer.diagnostics.errors ~= 0 and 'underline')
        or nil
    end,
    truncation = {
      priority = 2,
      direction = 'left',
    },
  },

  diagnostics = {
    text = function(buffer)
      return
        (buffer.diagnostics.errors ~= 0 and ' ' .. vim.fn.sign_getdefined("DiagnosticSignError")[1].text .. buffer.diagnostics.errors)
        or (buffer.diagnostics.warnings ~= 0 and ' ' .. vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text .. buffer.diagnostics.warnings)
        or ''
    end,
    fg = function(buffer)
      return
        (buffer.diagnostics.errors ~= 0 and errors_fg)
        or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
        or nil
    end,
    truncation = { priority = 1 },
  },

  close_or_unsaved = {
    text = function(buffer)
      return buffer.is_modified and '●' or '󰖭'
    end,
    fg = function(buffer)
      return buffer.is_modified and green or nil
    end,
    delete_buffer_on_left_click = true,
    truncation = { priority = 1 },
  },
}

require('cokeline').setup({
  show_if_buffers_are_at_least = 1,

  buffers = {
    -- filter_valid = function(buffer) return buffer.type ~= 'terminal' end,
    -- filter_visible = function(buffer) return buffer.type ~= 'terminal' end,
    new_buffers_position = 'last',
  },

  rendering = {
    max_buffer_width = 30,
  },

  default_hl = {
    fg = function(buffer)
      return
        buffer.is_focused
        and get_hex('Normal', 'fg')
         or get_hex('Comment', 'fg')
    end,
    bg = get_hex('ColorColumn', 'bg'),
  },

  sidebar = {
    filetype = 'neo-tree',
    components = {
      {
        text = ' neo-tree ',
        fg = yellow,
        bg = get_hex('NvimTreeNormal', 'bg'),
        style = 'bold',
      },
    }
  },

  components = {
    components.separator_left,
    components.devicon,
    components.index,
    components.unique_prefix,
    components.filename,
    components.diagnostics,
    components.two_spaces,
    components.close_or_unsaved,
    components.separator_right,
    components.space,
  },
})

vim.keymap.set('n', '<Tab>', '<Plug>(cokeline-focus-next)')
vim.keymap.set('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)')
vim.keymap.set('n', '<leader>b', '<Plug>(cokeline-pick-focus)')
