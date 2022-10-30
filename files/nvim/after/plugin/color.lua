-- Debug tips:
--   - `verbose hi <Name>` shows where the hi group is set.
--   - Run `:so $VIMRUNTIME/syntax/hitest.vim` to see all highlight groups.
--

-- set colorscheme
vim.cmd([[ colorscheme catppuccin ]])

-- custom color overrides
vim.cmd([[highlight IndentBlanklineIndent guifg=#3d3d3d gui=nocombine]])
vim.cmd([[highlight ColorColumn guibg=#1d1d2b]])
vim.cmd([[highlight SignColumn guibg=#1d1d2b]])
vim.cmd([[highlight CursorLine guibg=#1d1d2b]])
