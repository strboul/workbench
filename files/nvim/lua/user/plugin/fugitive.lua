vim.keymap.set(
  "n",
  "<leader>gb",
  ":Git blame<CR>",
  { desc = "Open git blame pane on buffer", noremap = true, silent = true }
)
