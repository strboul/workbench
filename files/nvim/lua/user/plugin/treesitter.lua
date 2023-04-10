-- Treesitter config.
--

-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
local languages = {
  "bash",
  "c",
  "comment", -- # TODO: overwrite todo colors with TS.
  "css",
  "dockerfile",
  "go",
  "hcl",
  "vimdoc",
  "html",
  "javascript",
  "json",
  "lua",
  "make",
  "python",
  "rust",
  "terraform",
  "typescript",
  "yaml",
}
require("nvim-treesitter.configs").setup({
  ensure_installed = languages,
  highlight = {
    enable = true, -- `false` disables whole extension
  },
})

-- TODO: make TSErrors visible only on Normal mode, not Insert mode.
