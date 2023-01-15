-- Debug tips:
--   - `verbose hi <Name>` shows where the hi group is set.
--   - Run `:so $VIMRUNTIME/syntax/hitest.vim` to see all highlight groups.

local user_utils = require("user.utils")
local catppuccin = require("catppuccin")

-- setup theme.
catppuccin.setup({
  flavour = "macchiato",
})

-- set colorscheme.
vim.cmd([[ colorscheme catppuccin ]])

-- Available highlight group variables.
local hl = {}
hl.search = user_utils.get_highlight("Search")
hl.color_column = user_utils.get_highlight("ColorColumn")
hl.sign_column = { bg = "#1d1d2b" }

-- [[ Custom defined highlights. ]]
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "red" })
vim.api.nvim_set_hl(0, "CursorLineActive", hl.color_column)

-- [[ User highlight overrides. ]]
vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { fg = "#3d3d3d", nocombine = true })
vim.api.nvim_set_hl(0, "ColorColumn", hl.sign_column)
vim.api.nvim_set_hl(0, "SignColumn", hl.sign_column)
vim.api.nvim_set_hl(0, "Todo", { bg = "#800000", fg = "#d0d090", italic = true })
vim.api.nvim_set_hl(0, "Error", { fg = "red", bold = true, undercurl = true })

-- [[ Plugin highlight overrides. ]]
vim.api.nvim_set_hl(0, "GitSignsAdd", hl.sign_column)
vim.api.nvim_set_hl(0, "GitSignsChange", hl.sign_column)
vim.api.nvim_set_hl(0, "GitSignsDelete", hl.sign_column)

-- Telescope.
-- Used for highlighting characters that you match.
vim.api.nvim_set_hl(0, "TelescopeMatching", user_utils.merge_tables(hl.search, { italic = true }))
