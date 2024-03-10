-- set up winbar on each viewport.
-- TODO:
-- - for vsplit, hide the winbar for the bottom if the split files are the same
--   file. (might be difficult)

local user_utils = require("user.utils")

local winbar = {}

-- Exclude filetypes where you don't want to have the winbar. It has to be
-- excluded at the function level because autocmd pattern doesn't support
-- inverting patterns yet (as of nvim 0.9.0).
function winbar.is_exclude_filetype(filetype)
  exclude_list = user_utils.set({ "TelescopePrompt", "NvimTree" })
  if exclude_list[filetype] then
    return true
  end
  return false
end

function winbar.is_exclude_bufname(bufname)
  exclude_list = user_utils.set({ "", "nofile" })
  if exclude_list[bufname] then
    return true
  end
  return false
end

function winbar.get_winbar(status)
  local filetype = vim.bo.filetype
  local bufname = vim.fn.expand("%")
  if winbar.is_exclude_filetype(filetype) then
    return nil
  end
  if winbar.is_exclude_bufname(bufname) then
    return nil
  end
  local winbar_content
  if status == "active" then
    winbar_content = table.concat({ "%#TabLineSel#", bufname, "%#WarningMsg#", "%m", "%#TabLineSel#" })
  elseif status == "inactive" then
    winbar_content = table.concat({ "%#TabLine#", bufname, "%#WarningMsg#", "%m", "%#TabLine#" })
  end
  -- Use try-catch in winbar there's an error:
  -- TODO: https://github.com/neovim/neovim/issues/19464
  local success, error_message = pcall(function()
    vim.opt_local.winbar = winbar_content
  end)
  if not success then
    print("[workbench] Error setting winbar:", error_message)
  end
end

local augroup_winbar = vim.api.nvim_create_augroup("Winbar", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  desc = "winbar on active buffer",
  group = augroup_winbar,
  callback = function()
    winbar.get_winbar("active")
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  desc = "winbar on inactive buffer",
  group = augroup_winbar,
  callback = function()
    winbar.get_winbar("inactive")
  end,
})
