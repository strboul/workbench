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
-- With file finder:
--   if the number of file selections are more than one, open all of them with
--   vsplit in the same window; else, just open the file in the same buffer.
--
-- With find word:
--   if the number of file selections are more than one, put them into the
--   quickfix window; else, just open the file in the same buffer.
--
function custom_actions.my_smart_select(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  -- There's no picker type or something, so I had to choose the prompt title
  -- (which is bad because it's configurable).
  local title = picker.prompt_title
  local multi_selection = picker:get_multi_selection()
  local num_selections = table.getn(multi_selection)
  if title == "Find Files" then
    if num_selections > 1 then
      for _, entry in ipairs(multi_selection) do
        vim.cmd(string.format("%s %s", ":vsplit!", entry.value))
      end
    else
      actions.file_edit(prompt_bufnr)
    end
  elseif title:match("^Find Word") then
    if num_selections > 1 then
      actions.send_selected_to_qflist(prompt_bufnr)
      actions.open_qflist()
      -- jump to the first qf match.
      vim.cmd.cc()
    else
      actions.file_edit(prompt_bufnr)
    end
  else
    actions.select_default(prompt_bufnr)
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
vim.api.nvim_create_user_command("Grep", function(opts)
  custom_commands.grep_command(opts.args)
end, { nargs = 1 })

-- Package setup.
telescope.setup({
  pickers = {
    find_files = {
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
        ["<cr>"] = custom_actions.my_smart_select,
        ["<C-a>"] = actions.select_all,
      },
      n = {
        ["<cr>"] = custom_actions.my_smart_select,
        ["<C-a>"] = actions.select_all,
      },
    },
  },
})
