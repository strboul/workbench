require("Comment").setup({
  -- add a space after comment.
  padding = true,
  -- the cursor should stay at its position.
  sticky = true,
  toggler = {
    ---Line-comment toggle keymap
    line = "<leader>cc",
    block = "<leader>cc",
  },
  -- don't have the extra mappings
  mappings = {
    extra = false,
  },
})
