-- Telescope
-- https://github.com/nvim-telescope/telescope.nvim
require("telescope").setup()

-- Keybindings
vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "ctrl+p pfiles" })
vim.keymap.set("n", "<C-t>", require("telescope.builtin").builtin, { desc = "ctrl+t Telescope" })
vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers, { desc = "leader buffers" })
