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

-- Log a message to a file.
-- https://www.lua.org/pil/21.1.html
--
-- Details:
-- Useful for logging nvim events, such as:
--   require(user.utils).log_file('log1.log', vim.inspect(picker))
--
M.log_file = function(file_path, message)
  local file = io.open(file_path, "w")
  io.output(file)
  io.write(message)
  io.close(file)
end

-- FIXME
M.get_visual_selection = function()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
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
