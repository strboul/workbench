local gitsigns = require("gitsigns")

gitsigns.setup()

vim.keymap.set("n", "<leader>gq", ":Gitsigns setqflist all<CR>", { desc = "Send changes to qf" })
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk inline" })
vim.keymap.set("n", "<leader>gx", ":Gitsigns toggle_signs<CR>", { desc = "Toggle git signs" })
