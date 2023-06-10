-- Setting options
--

local o = vim.opt
local g = vim.g
local cmd = vim.cmd

-- [[ general ]]
-- leader key.
g.mapleader = " "
g.maplocalleader = " "
-- enable mouse.
o.mouse = "a"
-- no backup, swap, etc. VCS everywhere.
o.swapfile = false
o.backup = false
o.writebackup = false
-- right click on mouse extends selection instead of showing popup-menu.
o.mousemodel = "extend"
-- 24-bit RGB, use 'gui' instead of 'cterm' attributes
o.termguicolors = true
-- no splash screen at the start `:h intro`
o.shortmess:append("I")
-- no file written message.
o.shortmess:append("W")
-- virtual editing on the window, can do block/rectangular selections:
o.virtualedit = "block"
-- default textwidth
o.textwidth = 80
-- darken after the 80th char
cmd([[ let &colorcolumn=join(range(81,500),",") ]])
-- timeout when a special key (ESC, leader, etc.) pressed.
o.timeout = true
o.timeoutlen = 500
o.ttimeout = true
o.ttimeoutlen = 10
-- default (4000 ms) is too slow but also a too low value can be annoying.
o.updatetime = 400

-- [[ windows ]]
-- show the cursor position in the statusline.
o.ruler = true
-- off lines with high value to keep cursor more in center.
o.scrolloff = 8
-- always open h-splits at the right side
o.splitright = true
-- always open v-splits at the below side
o.splitbelow = true
-- don't show line numbers
o.number = false
-- horizontal cursor bar for the current line
o.cursorline = true
-- enable break indent
o.breakindent = true
-- always show signcolumn for linting, diagnostics, etc.
o.signcolumn = "yes:1"

-- [[ searching]]
-- set highlight on search
o.hlsearch = true
-- case insensitive search
o.ignorecase = true
-- if any upper case, then case sensitive search
o.smartcase = true
-- start matching as soon as something is typed
o.incsearch = true
-- preview substitution in split window
o.inccommand = "split"

-- [[ indentation and spacing ]]
-- don't wrap
o.wrap = false
-- insert 2 spaces for a tab
o.tabstop = 2
-- use 2 spaces when indenting
o.shiftwidth = 2
-- tabbing detects when e.g. you have 2 or 4
o.smarttab = true
-- convert tab to spaces
o.expandtab = true
-- makes indenting smart
o.smartindent = true
-- use indendation of previous line
o.autoindent = true

-- listchars
o.list = true
o.listchars:append({ tab = "¦ " })
o.listchars:append({ trail = "·" })
