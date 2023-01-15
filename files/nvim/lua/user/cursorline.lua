local augroup_cursorline = vim.api.nvim_create_augroup("CursorLine", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter" }, {
  desc = "Active window cursor line settings",
  group = augroup_cursorline,
  callback = function()
    vim.cmd([[
      setlocal cursorline
      setlocal winhighlight=CursorLine:CursorLineActive
    ]])
  end,
})

-- don't show cursorline on inactive window.
vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
  desc = "Inactive window cursor line settings",
  group = augroup_cursorline,
  callback = function()
    vim.cmd([[ setlocal nocursorline ]])
  end,
})

local augroup_cursorline_normal_mode = vim.api.nvim_create_augroup("CursorLineNormalMode", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  desc = "Disable cursorline on insert mode",
  group = augroup_cursorline_normal_mode,
  callback = function()
    vim.cmd([[ setlocal nocursorline ]])
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  desc = "Enable back cursorline on normal mode",
  group = augroup_cursorline_normal_mode,
  callback = function()
    vim.cmd([[ setlocal cursorline ]])
  end,
})
