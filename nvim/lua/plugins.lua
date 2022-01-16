-- -- You must run this or `PackerSync` whenever you make changes to your plugin configuration
-- :PackerCompile
--
-- -- Only install missing plugins
-- :PackerInstall
--
-- -- Update and install plugins
-- :PackerUpdate
--
-- -- Remove any disabled or unused plugins
-- :PackerClean
--
-- -- Performs `PackerClean` and then `PackerUpdate`
-- :PackerSync
--

-- use a different path from the rest of the nvim config:
local package_root = os.getenv("XDG_CONFIG_HOME") + "/nvim2/packer.nvim/site/pack"
local compile_path = os.getenv("XDG_CONFIG_HOME") + "/nvim2/packer.nvim/plugin/packer_compiled.lua"

function install_packer()
  if vim.fn.empty(vim.fn.glob(package_root)) > 0 then
    vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..package_root)
  end
end
install_packer()

vim.cmd [[packadd packer.nvim]]

local packer = require "packer"

packer.init { compile_path = compile_path }

packer.startup(function()
  -- Packer can manage itself
  use 'https://github.com/wbthomason/packer.nvim'

  use {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'https://github.com/mhartington/oceanic-next',
    config = function()
      vim.g.oceanic_next_terminal_bold = 1
      vim.g.oceanic_next_terminal_italic = 1

      vim.api.nvim_exec([[
        function! OceanicNextTweak()
          highlight Comment gui=italic
          highlight SignColumn guibg=#1c1c1c
          highlight Todo guibg=#800000 guifg=#d0d090
        endfunction

        augroup colorschemes
          autocmd!
          autocmd VimEnter,ColorScheme * call OceanicNextTweak()
        augroup END
      ]], true)

    end
  }

  use {
    'https://github.com/hoob3rt/lualine.nvim',
    requires = {'https://github.com/kyazdani42/nvim-web-devicons'},
    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight'
        }
      }
    end,
  }

  use {
    'https://github.com/nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'}
    },
    config = function()
      vim.api.nvim_exec([[
        nnoremap <c-p> <cmd>lua require('telescope.builtin').find_files()<cr>
      ]], true)
    end
  }

end)
