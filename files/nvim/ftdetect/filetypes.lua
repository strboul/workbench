-- Common file extensions & types
--

local augroup_common_filetypes = vim.api.nvim_create_augroup("CommonFiletypes", { clear = true })

-- On text files:
-- - check spelling
-- - do automatic word wrapping on markdown files
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Rules on text files",
  group = augroup_common_filetypes,
  pattern = { "*.txt", "*.md" },
  callback = function()
    vim.cmd([[
      setlocal spell spelllang=en_us
      setlocal wrap textwidth=79
    ]])
  end,
})

-- PEP-8 recommends 4 spaces, instead of tabs
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Rules on python files",
  group = augroup_common_filetypes,
  pattern = "python",
  callback = function()
    vim.cmd([[
      setlocal tabstop=4
      setlocal softtabstop=4
      setlocal shiftwidth=4
      setlocal smartindent
    ]])
  end,
})

-- go fmt uses tab instead of spaces.
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Rules on go files",
  group = augroup_common_filetypes,
  pattern = "go",
  callback = function()
    vim.cmd([[
      setlocal tabstop=4
      setlocal noexpandtab
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Rules on yaml files",
  group = augroup_common_filetypes,
  pattern = { "yaml", "yaml.*" },
  callback = function()
    vim.cmd([[
      setlocal tabstop=2
      setlocal shiftwidth=2
      " remove some indenting rules
      setlocal indentexpr=
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Rules on make files",
  group = augroup_common_filetypes,
  pattern = "make",
  callback = function()
    vim.cmd([[
      setlocal noexpandtab
    ]])
  end,
})
