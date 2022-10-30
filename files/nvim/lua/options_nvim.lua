-- Setting options
-- See `:help vim.o`

-- [[ general ]]
-- leader key space
vim.g.mapleader = " "
-- enable mouse
vim.o.mouse = "a"
-- 24-bit RGB, use 'gui' instead of 'cterm' attributes
vim.o.termguicolors = true
-- no splash screen at the start `:h intro`
vim.o.shortmess = vim.o.shortmess .. "I"
-- no file written message
vim.o.shortmess = vim.o.shortmess .. "W"
-- virtual editing on the window, can do block/rectangular selections:
vim.o.virtualedit = block
-- darken after the 80th char
vim.cmd([[ let &colorcolumn=join(range(81,500),",") ]])

-- [[ windows ]]
-- show the cursor position in the statusline.
vim.o.ruler = true
-- off lines with high value to keep cursor more in center.
vim.o.scrolloff = 8
-- always open h-splits at the right side
vim.o.splitright = true
-- always open v-splits at the below side
vim.o.splitbelow = true
-- don't show line numbers
vim.wo.number = false
-- horizontal cursor bar for the current line
vim.wo.cursorline = true
-- enable break indent
vim.o.breakindent = true
-- always show signcolumn for linting, diagnostics, etc.
vim.wo.signcolumn = "yes:1"

-- [[ searching]]
-- set highlight on search
vim.o.hlsearch = true
-- case insensitive search
vim.o.ignorecase = true
-- if any upper case, then case sensitive search
vim.o.smartcase = true
-- start matching as soon as something is typed
vim.o.incsearch = true
-- preview substitution in split window
vim.o.inccommand = "split"

-- [[ indentation and spacing ]]
-- don't wrap
vim.wo.wrap = false
-- insert 2 spaces for a tab
vim.opt.tabstop = 2
-- use 2 spaces when indenting
vim.opt.shiftwidth = 2
-- tabbing detects when e.g. you have 2 or 4
vim.opt.smarttab = true
-- convert tab to spaces
vim.opt.expandtab = true
-- makes indenting smart
vim.opt.smartindent = true
-- use indendation of previous line
vim.opt.autoindent = true

-- listchars
vim.opt.list = true
vim.opt.listchars:append({ tab = "¦ " })
vim.opt.listchars:append({ trail = "·" })

-- highlight on yank
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 750 })
  end,
})
