-- Various nvim autoloads.
--

local augroup_autosave_buffer = vim.api.nvim_create_augroup("AutoSaveBuffer", { clear = true })

-- FIXME: why it's lagging??
vim.api.nvim_create_autocmd({ "BufLeave", "CursorHold", "FocusLost" }, {
  desc = [[
    Auto save on focus out (but not in insert-mode, which is `CursorHoldI`).
  ]],
  group = augroup_autosave_buffer,
  callback = function()
    vim.cmd([[ silent! wa ]])
  end,
})

local augroup_trailing_whitespace = vim.api.nvim_create_augroup("TrailingWhitespace", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = [[
    Show trailing whitespace and spaces before a tab (except when typing at the
    end of a line).
  ]],
  group = augroup_trailing_whitespace,
  callback = function()
    -- FIXME: doesn't work.
    -- FIXME: make it array.includes check.
    if vim.bo.buftype == "terminal" or vim.bo.buftype == "nofile" then
      return
    end
    vim.cmd([[ match TrailingWhitespace /\s\+\%#\@<!$/ ]])
  end,
})

local augroup_navi = vim.api.nvim_create_augroup("Navi", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  desc = "Set filetype for navi.",
  group = navi,
  pattern = "*.cheat",
  command = "setlocal filetype=navi",
})

local augroup_highlight_yank = vim.api.nvim_create_augroup("HighlightYank", { clear = true })

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "Highlight word(s) when yanked with `y`.",
  group = augroup_highlight_yank,
  callback = function()
    vim.highlight.on_yank({ timeout = 750 })
  end,
})

local augroup_restore_last_cursor = vim.api.nvim_create_augroup("RestoreLastCursorPosition", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  desc = "Restore cursor position when opening file (from :marks)",
  group = augroup_restore_last_cursor,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local augroup_file_changed = vim.api.nvim_create_augroup("MessageFileChanged", { clear = true })

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  desc = "Echo message on command after file change",
  group = augroup_file_changed,
  callback = function()
    vim.cmd([[
      echohl WarningMsg |
      \ echo "File changed on disk. Buffer reloaded." |
      \ echohl None
    ]])
  end,
})

local augroup_highlight_non_ascii = vim.api.nvim_create_augroup("HighlightNonAsciiChars", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead" }, {
  desc = "Highlight non-ASCII characters",
  group = augroup_highlight_non_ascii,
  callback = function()
    vim.cmd([[
      syntax match SpellBad "[^\x00-\x7F]" containedin=all
    ]])
  end,
})
