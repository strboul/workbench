--[[
packer package manager
https://github.com/wbthomason/packer.nvim

Notes:
- When you change this file, don't forget to run `:PackerCompile`.
-

--]]

vim.cmd([[ packadd packer.nvim ]])

require("packer").startup(function(use)
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
