--[[
General lua notes:

- Use `table.concat` instead of `..` for string concatenation.
-

--]]

-- disable netrw
vim.api.nvim_set_var("loaded_netrw", 1)
vim.api.nvim_set_var("loaded_netrwPlugin", 1)

-- TODO: move them to after/ folder?
require("utils_nvim")
require("options_nvim")

require("packer_nvim")
require("telescope_nvim")
require("indent_blankline_nvim")
require("comment_nvim")

require("mappings_nvim")
require("statusline_nvim")
require("tabline_nvim")
require("winbar_nvim")

-- XXX temp code below
