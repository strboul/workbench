vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("TrailingWhitespace", { clear = true }),
  pattern = "*",
  callback = function()
    vim.cmd([[match TrailingWhitespace /\s\+\%#\@<!$/]])
  end,
  desc = [[
    Show trailing whitespace and spaces before a tab (except when typing at the
    end of a line).
  ]],
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup("Navi", { clear = true }),
  pattern = "*.cheat",
  command = "setlocal filetype=navi",
  desc = "Set filetype for navi.",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 750 })
  end,
  desc = "Highlight word(s) when yanked with `y`.",
})
