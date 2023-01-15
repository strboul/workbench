-- MY's custom helpers.

local M = {}

-- Copy a visual selection with markdown compatible output.
-- It can be help for literal programming.
M.copy_with_metadata = function()
  -- get visual selection range
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  -- get buffer lines by range
  local buf_lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local linestr = table.concat(buf_lines, "\n")
  local selected = table.concat({ "```", linestr, "```" }, "\n")
  -- get path
  local current_dir = vim.fn.fnamemodify(vim.loop.cwd(), ":t")
  local current_bufname = vim.fn.expand("%")
  local path = table.concat({ current_dir, "/", current_bufname })
  -- row numbers
  local row_nums
  if start_row == end_row then
    row_nums = start_row
  else
    row_nums = table.concat({ start_row, "-", end_row })
  end
  -- file identifier
  local file_id = table.concat({ "> ", path, ":", row_nums })
  -- save to register
  local out = table.concat({ file_id, selected }, "\n")
  print(out)
  vim.fn.setreg("+", out)
end

-- Get name of the vim highlight name under the cursor.
-- Useful for color scheme/syntax.
M.get_vim_hl_name_under_cursor = function()
  vim.cmd([[ echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') ]])
end

-- Commands

vim.api.nvim_create_user_command("CopyWithMetadata", function()
  M.copy_with_metadata()
end, { range = true })

vim.api.nvim_create_user_command("GetVimHighlightNameUnderCursor", function()
  M.get_vim_hl_name_under_cursor()
end, {})

return M
