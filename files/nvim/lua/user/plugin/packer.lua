--[[
packer package manager
https://github.com/wbthomason/packer.nvim

Notes:
- When you change this file, don't forget to run `:PackerCompile`.
-
--]]

local user_utils = require("user.utils")
local packer = require("packer")

-- Autoupdate packer.nvim if the last update was x time ago. Keep the last update
-- date in the disk.
--
local function autoupdate()
  local filepath = table.concat({
    os.getenv("HOME"),
    "/.config/nvim/.plugin_last_updated",
  })
  if not user_utils.file_exists(filepath) then
    user_utils.file_write(filepath, os.time())
    return
  end
  local file_ts = user_utils.file_read(filepath)
  local diff = os.date("%d", os.difftime(os.time(), tonumber(file_ts)))
  local diff_days_limit = 7
  if tonumber(diff) > diff_days_limit then
    packer.compile()
    packer.update()
    user_utils.file_write(filepath, os.time())
  end
end
local augroup_autoupdate = vim.api.nvim_create_augroup("PackerAutoUpdate", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  desc = [[
    Automatically update the plugin packages if the date last passed x days.
  ]],
  group = augroup_autoupdate,
  callback = autoupdate,
})

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
  use("https://github.com/nvim-tree/nvim-tree.lua")

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
