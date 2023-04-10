local M = {}

-- Set
-- https://www.lua.org/pil/11.5.html
M.set = function(list)
  local set = {}
  for _, elem in ipairs(list) do
    set[elem] = true
  end
  return set
end

-- Write a message to a file.
-- https://www.lua.org/pil/21.1.html
--
-- Details:
-- Useful for logging nvim events, such as:
--   require("user.utils").file_write('log1.log', vim.inspect(picker))
--
M.file_write = function(filepath, message)
  local file = io.open(filepath, "w")
  io.output(file)
  io.write(message)
  io.close(file)
end

-- Returns boolean whether a file exists.
M.file_exists = function(filepath)
  local file = io.open(filepath, "r")
  return file ~= nil and io.close(file)
end

M.file_read = function(filepath)
  local file = io.open(filepath, "r")
  local content = file:read("*a")
  io.close(file)
  return content
end

-- https://github.com/neovim/neovim/pull/13896
M.get_visual_selection = function()
  local _, start_line, start_col, _ = unpack(vim.fn.getpos("v"))
  local _, end_line, end_col, _ = unpack(vim.fn.getpos("."))
  -- if visual selection started from bottom to top
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  -- if visual selection started from right to left
  if start_col > end_col then
    start_col, end_col = end_col, start_col
  end
  return vim.api.nvim_buf_get_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, {})
end

M.num_to_hex = function(num)
  return string.format("#%06x", num)
end

M.get_highlight = function(name)
  local highlight = vim.api.nvim_get_hl_by_name(name, true)
  -- map some keys to the format that `vim.api.nvim_set_hl understands`, no idea why
  -- it's not standard return from `vim.api.nvim_get_hl_by_name`!
  local rename_map = { foreground = "fg", background = "bg" }
  local out = {}
  local k, v
  for k, v in pairs(highlight) do
    if rename_map[k] ~= nil then
      k = rename_map[k]
      v = M.num_to_hex(v)
    end
    out[k] = v
  end
  return out
end

-- Merge/concatenate two tables.
-- (Another missing util from Lua.)
--
-- Details:
-- - On purpose this util isn't named with 'concat' to not to confuse with the
--   builtin `table.concat`.
-- - The second table will overwrite the values from the first table in case
--   the keys are the same.
--
M.merge_tables = function(table1, table2)
  local result = {}
  for k, v in pairs(table1) do
    result[k] = v
  end
  for k, v in pairs(table2) do
    result[k] = v
  end
  return result
end

return M
