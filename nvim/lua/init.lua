vim.cmd([[set runtimepath=~/.config/nvim2]])
vim.cmd([[set packpath=~/.config/nvim2]])

require("utils")
require("plugins")

-- Neovim automatically runs :PackerCompile whenever plugins.lua is updated:
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

vim.cmd([[colorscheme OceanicNext]])

-- required vim files
vim.cmd("source $HOME/dotfiles/nvim/essential.vim")
vim.cmd("source $HOME/dotfiles/nvim/filetypes.vim")
vim.cmd("source $HOME/dotfiles/nvim/mappings.vim")
vim.cmd("source $HOME/dotfiles/nvim/autocmds.vim")
vim.cmd("source $HOME/dotfiles/nvim/terminal.vim")
