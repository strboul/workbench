local gitsigns = require("gitsigns")

gitsigns.setup()

-- TODO get next and previous hunks globally
local function next_hunk()
  gitsigns.next_hunk({ preview = true })
end

local function prev_hunk()
  gitsigns.prev_hunk({ preview = true })
end

local function setqflist()
  gitsigns.setqflist({ all = true })
end

vim.keymap.set("n", "<leader>ghn", next_hunk, { desc = "Go next hunk change" })
vim.keymap.set("n", "<leader>ghp", prev_hunk, { desc = "Go previous hunk change" })
vim.keymap.set("n", "<leader>gq", setqflist, { desc = "Send changes to qf" })
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk inline" })
vim.keymap.set("n", "<leader>gx", ":Gitsigns toggle_signs<CR>", { desc = "Toggle git signs" })
