local which_key = require("which-key")
which_key.setup({
  plugins = {
    marks = false, -- I don't use marks.
  },
  disable = {
    filetypes = { "TelescopePrompt", "NvimTree" },
  },
})
which_key.register({
  ["<leader>g"] = {
    name = "+git",
  },
  ["<leader>c"] = {
    name = "+coc",
  },
})
