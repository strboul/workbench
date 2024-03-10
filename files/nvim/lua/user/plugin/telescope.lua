-- Telescope
-- https://github.com/nvim-telescope/telescope.nvim
--

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local custom_actions = {}
local custom_commands = {}

-- My smart select on Telescope
--
-- If there is a multi selection, put the selected ones into the quickfix
-- window; else, open the file in the current buffer.
--
function custom_actions.my_smart_select(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = table.getn(picker:get_multi_selection())
  if num_selections > 1 then
    actions.send_selected_to_qflist(prompt_bufnr)
    actions.open_qflist()
    -- jump to the first qf match.
    vim.cmd.cc()
  else
    actions.file_edit(prompt_bufnr)
  end
end

function custom_commands.grep_command(query)
  builtin.grep_string({ search = query })
end

function custom_commands.any_jump_visual_mode()
  local visual_select = require("user.utils").get_visual_selection()
  builtin.grep_string({ search = table.concat(visual_select) })
end

function custom_commands.any_jump_normal_mode()
  local word_under_cursor = vim.fn.expand("<cword>")
  builtin.grep_string({ search = word_under_cursor })
end

-- Keybindings
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Files" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Buffers" })

vim.keymap.set("n", "<leader>j", custom_commands.any_jump_normal_mode, { desc = "Jump search" })
vim.keymap.set("v", "<leader>j", custom_commands.any_jump_visual_mode, { desc = "Jump search" })

-- Custom commands.
vim.api.nvim_create_user_command("G", function(opts)
  custom_commands.grep_command(opts.args)
end, { nargs = 1 })

-- Package setup.
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
telescope.setup({
  pickers = {
    find_files = {
      theme = "dropdown",
      -- use `fd` for finding and show hidden files.
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
    },
  },

  defaults = {
    -- All mappings.
    -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
    mappings = {
      i = {
        ["<esc>"] = actions.close, -- also easy close in insert mode.
        ["<tab>"] = actions.toggle_selection,
        ["<cr>"] = custom_actions.my_smart_select,
        ["<C-a>"] = actions.select_all,
        ["<ScrollWheelUp>"] = actions.preview_scrolling_up,
        ["<ScrollWheelDown>"] = actions.preview_scrolling_down,
        -- use <C-u> to clear the prompt instead of scrolling the previewer.
        ["<C-u>"] = false,
        -- no need to keep scrolling previewer down as scroll up is used for clear the prompt.
        ["<C-d>"] = false,
      },
      n = {
        ["<tab>"] = actions.toggle_selection,
        ["<cr>"] = custom_actions.my_smart_select,
        ["<C-a>"] = actions.select_all,
      },
    },

    -- `telescope.builtin.grep_string` uses this config.
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
  },
})
