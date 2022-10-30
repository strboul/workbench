-- packer package manager
-- https://github.com/wbthomason/packer.nvim
--

vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- package manager.
  use("https://github.com/wbthomason/packer.nvim")

  -- git in nvim.
  -- XXX slow. change to a lua version in the first chance (mainly for git blame).
  use("https://github.com/tpope/vim-fugitive")

  -- fugitive-companion to interact with github.
  use("https://github.com/tpope/vim-rhubarb")

  -- comment/uncomment.
  use("https://github.com/numToStr/Comment.nvim")

  -- fuzzy finder (files, lsp, etc.).
  use({
    "https://github.com/nvim-telescope/telescope.nvim",
    requires = { "https://github.com/nvim-lua/plenary.nvim" },
  })

  -- file drawer/explorer.
  use({
    "https://github.com/nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        filters = {
          dotfiles = true,
        },
      })
    end,
  })

  -- indent bars.
  use("https://github.com/lukas-reineke/indent-blankline.nvim")

  -- color.
  use({
    "https://github.com/catppuccin/nvim",
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.95,
        },
      })
    end,
  })
end)
