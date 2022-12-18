-- TODO
-- Experimental plugin.
local telescope = require("telescope")
local command_center = require("command_center")

vim.keymap.set("n", "<leader>t", ":Telescope command_center<CR>")

command_center.add({
  {
    desc = "Telescope: Search inside current buffer",
    cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
    keys = { "n", "<leader>fl", noremap },
  },
  {
    -- You can specify multiple keys for the same cmd ...
    desc = "Telescope: Show document symbols",
    cmd = "<CMD>Telescope lsp_document_symbols<CR>",
    keys = {
      { "n", "<leader>ss", noremap },
      { "n", "<leader>ssd", noremap },
    },
    { desc = "Telescope: Command History", cmd = "<CMD>Telescope command_history<CR>" },

    { desc = "Telescope: Tags", cmd = "<CMD>Telescope tags<CR>" },

    { desc = "Telescope: Help Tags", cmd = "<CMD>Telescope help_tags<CR>" },
    { desc = "Telescope: Man Pages", cmd = "<CMD>Telescope man_pages<CR>" },
    { desc = "Telescope: VIM Options", cmd = "<CMD>Telescope vim_options<CR>" },
    { desc = "Telescope: Colorschemes", cmd = "<CMD>Telescope colorschemes<CR>" },
    { desc = "Telescope: Autocommands", cmd = "<CMD>Telescope: autocommands" },
    { desc = "Telescope: Keymaps", cmd = "<CMD>Telescope: keymaps" },
    { desc = "Telescope: Filetypes", cmd = "<CMD>Telescope: filetypes" },

    { desc = "Telescope: Registers", cmd = "<CMD>Telescope registers<CR>" },
    { desc = "Telescope: Quickfix", cmd = "<CMD>Telescope quickfix<CR>" },
    { desc = "Telescope: Location List", cmd = "<CMD>Telescope loclist<CR>" },
  },
})

telescope.load_extension("command_center")
