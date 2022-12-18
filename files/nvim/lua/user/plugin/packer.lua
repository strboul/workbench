--[[
packer package manager
https://github.com/wbthomason/packer.nvim

Notes:
- When you change this file, don't forget to run `:PackerCompile`.
-

--]]

vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- package manager.
  use("https://github.com/wbthomason/packer.nvim")

  -- git in nvim.
  -- XXX slow. change to a lua version in the first chance (mainly for git blame).
  use("https://github.com/tpope/vim-fugitive")

  -- fugitive-companion to interact with github.
  use("https://github.com/tpope/vim-rhubarb")

  -- fuzzy finder (files, lsp, etc.).
  use({
    "https://github.com/nvim-telescope/telescope.nvim",
    requires = { "https://github.com/nvim-lua/plenary.nvim" },
  })

  -- file drawer.
  use("https://github.com/nvim-tree/nvim-tree.lua")

  -- urlview.
  use({
    "https://github.com/axieax/urlview.nvim",
    config = function()
      require("urlview").setup({
        default_picker = "telescope",
      })
    end,
  })

  -- indent bars.
  use("https://github.com/lukas-reineke/indent-blankline.nvim")

  -- git signs.
  -- XXX check some setup.
  use({
    "https://github.com/lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  })

  -- color theme.
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

  -- automatically expand the current window.
  -- FIXME: wip.
  use({
    "https://github.com/anuvyklack/windows.nvim",
    requires = { "https://github.com/anuvyklack/middleclass" },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()
    end,
  })

  use({
    "https://github.com/pearofducks/ansible-vim",
    config = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("Ansible", { clear = true }),
        pattern = {
          "*/playbooks/*.yml",
        },
        command = "set filetype=yaml.ansible",
        desc = "autodetect ansible file types",
      })
    end,
  })

  use({
    "https://github.com/gfeiyou/command-center.nvim",
    requires = { "https://github.com/nvim-telescope/telescope.nvim" },
  })
end)
