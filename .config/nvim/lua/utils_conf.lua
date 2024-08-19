-- Concise way to escape termcodes
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

function StripTrailingWhitespaces()
  local save_state = vim.fn.winsaveview()
  vim.cmd[[keeppatterns %s/\s\+$//e]]
  vim.cmd[[keeppatterns %s/\n\{3,}/\r\r/e]]
  vim.fn.winrestview(save_state)
end

function CursorHoldWriteFile()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local mod = vim.api.nvim_buf_get_option(0, "modifiable")
  local buf_type = vim.api.nvim_buf_get_option(0, "buftype")
  if mod and buf_name ~= "" and buf_type == "" then
    vim.cmd("update")
  end
end

function ClearNoiceAndHL()
  require("notify").dismiss({ silent = true, pending = true })
  vim.cmd("nohl")
  vim.fn.feedkeys("<C-L><CR>")
end

function InputQEvery3Seconds()
  local timer = vim.uv.new_timer()
  local i = 1
  timer:start(3000, 3000, vim.schedule_wrap(function()
    if i > 5 then
      timer:close()
    else
      vim.fn.feedkeys("Q")
      i = i + 1
    end
  end))
end
