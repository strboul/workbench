local M = {}

-- Set
-- https://www.lua.org/pil/11.5.html
function M.set(list)
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
function M.log_file(file_path, message)
  local file = io.open(file_path, "w")
  io.output(file)
  io.write(message)
  io.close(file)
end

-- FIXME
function M.get_visual_selection()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

return M
