local nvim_tree = require("nvim-tree")

local custom_commands = {}

-- disable netrw.
vim.api.nvim_set_var("loaded_netrw", 1)
vim.api.nvim_set_var("loaded_netrwPlugin", 1)

function custom_commands.open_file()
  require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
  local toggle = ":NvimTreeFindFileToggle"
  vim.cmd(toggle)
  -- FIXME doesn't work.
  -- local center_screen = ":normal! zz"
  -- vim.cmd(center_screen)
  -- vim.api.nvim_feedkeys("zz", 'n', true)
end

vim.keymap.set(
  "n",
  "<leader>n",
  custom_commands.open_file,
  { desc = "leader+n nvim-tree open", noremap = true, silent = true }
)

nvim_tree.setup({
  view = {
    adaptive_size = true,
    side = "right",
    -- See full list in `:h nvim-tree-default-mappings`.
    mappings = {
      custom_only = false,
      list = {
        { key = { "q", "<Esc>" }, action = "close" }, -- easy close.
        { key = "v", action = "vsplit" },
        { key = "s", action = "split" },
        { key = "t", action = "tabnew" },
      },
    },
  },
  filters = {
    dotfiles = true,
    exclude = { "^\\.git$" },
  },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = true,
        -- first use numbers then characters.
        chars = "1234567890ABCDEFGH",
      },
    },
  },
})
