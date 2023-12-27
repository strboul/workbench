--[[
packer package manager
https://github.com/wbthomason/packer.nvim

Notes:
- When you change this file, don't forget to run `:PackerCompile`.
-
--]]

local user_utils = require("user.utils")
local packer = require("packer")

local plugin_updates = {}

function plugin_updates.last_updated_filepath()
  return table.concat({ os.getenv("HOME"), "/.config/nvim/.plugin_last_updated" })
end

function plugin_updates.reminder()
  local filepath = plugin_updates.last_updated_filepath()
  -- initialize the file if not exists
  if not user_utils.file_exists(filepath) then
    user_utils.file_write(filepath, os.time())
    return
  end
  -- if last updated is greater than the time specified, raise a
  -- message
  local file_ts = user_utils.file_read(filepath)
  local diff_days = os.date("%d", os.difftime(os.time(), tonumber(file_ts)))
  local diff_days_limit = 7
  if tonumber(diff_days) > diff_days_limit then
    vim.api.nvim_echo({ { "[workbench] Time to update packer `:PackUpdate`", "WarningMsg" } }, true, {})
  end
end

function plugin_updates.packer_update()
  local filepath = plugin_updates.last_updated_filepath()
  packer.compile()
  packer.update()
  user_utils.file_write(filepath, os.time())
end

local augroup_autoupdate = vim.api.nvim_create_augroup("PackerUpdateReminder", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  desc = [[ Reminder to update plugins on start. ]],
  group = augroup_autoupdate,
  callback = plugin_updates.reminder,
})

vim.api.nvim_create_user_command("PackUpdate", plugin_updates.packer_update, {})

vim.cmd([[ packadd packer.nvim ]])

packer.startup(function(use)
  -- package manager.
  use("https://github.com/wbthomason/packer.nvim")

  -- fuzzy finder.
  use({
    "https://github.com/nvim-telescope/telescope.nvim",
    requires = { "https://github.com/nvim-lua/plenary.nvim" },
  })

  -- file drawer.
  use({ "https://github.com/nvim-tree/nvim-tree.lua", commit = "9ef6c3cd8805d868d20106be09ce07f004e8232f" }) -- XXX

  -- treesitter.
  use({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  })

  -- coc.nvim.
  use({ "https://github.com/neoclide/coc.nvim", branch = "release" })

  -- which key.
  use({ "https://github.com/folke/which-key.nvim" })

  -- indentation bars.
  use("https://github.com/lukas-reineke/indent-blankline.nvim")

  -- [[ Git plugins ]]
  -- git in nvim.
  -- XXX slow. change to a lua version in the first chance (mainly for git blame).
  use("https://github.com/tpope/vim-fugitive")

  -- improve `ga` reveal.
  use("https://github.com/tpope/vim-characterize")

  -- git signs.
  use({ "https://github.com/lewis6991/gitsigns.nvim" })

  -- color themes.
  use({ "https://github.com/catppuccin/nvim" })

  -- ansible.
  use({ "https://github.com/pearofducks/ansible-vim" })
end)
