-- set up winbar on each viewport.
-- TODO:
-- - for vsplit, hide the winbar for the bottom if the split files are the same
--   file. (might be difficult)

local user_utils = require("user.utils")

-- Exclude filetypes where you don't want to have the winbar. It has to be
-- excluded at the function level because autocmd pattern doesn't support
-- inverting patterns yet (as of nvim 0.9.0).
local function _is_exclude_filetype()
  local filetype = vim.bo.filetype
  exclude_list = user_utils.set({ "TelescopePrompt", "NvimTree" })
  if exclude_list[filetype] then
    return true
  end
  return false
end

local function _winbar(status)
  local is_ft_status = _is_exclude_filetype()
  if is_ft_status then
    return nil
  end
  local bufname = vim.fn.expand("%")
  if bufname == "" then
    return nil
  end
  if status == "active" then
    vim.opt_local.winbar = table.concat({ "%#TabLineSel#", bufname, "%#WarningMsg#", "%m", "%#TabLineSel#" })
  elseif status == "inactive" then
    vim.opt_local.winbar = table.concat({ "%#TabLine#", bufname, "%#WarningMsg#", "%m", "%#TabLineSel#" })
  end
end

Winbar = {
  active = function()
    _winbar("active")
  end,
  inactive = function()
    _winbar("inactive")
  end,
}

local augroup_winbar = vim.api.nvim_create_augroup("Winbar", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = augroup_winbar,
  pattern = "*",
  callback = function()
    Winbar.active()
  end,
  desc = "winbar on active buffer",
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = augroup_winbar,
  pattern = "*",
  callback = function()
    Winbar.inactive()
  end,
  desc = "winbar on inactive buffer",
})
