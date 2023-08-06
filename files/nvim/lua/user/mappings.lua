-- Create new lines in Normal mode.
vim.keymap.set("n", "o", "o<Esc>")
vim.keymap.set("n", "O", "O<Esc>")

-- Make cw consistent with dw (delete word with whitespace).
vim.cmd([[ map cw dwi ]])

-- Make Y consistent with D (yanks until the end of the line).
vim.cmd([[ map Y y$ ]])

-- Disable F1 key opening the vim-help.
vim.keymap.set("n", "<F1>", "<nop>")
vim.keymap.set("i", "<F1>", "<nop>")

-- Better x (don't push it to the register).
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "X", '"_X')

-- get to the middle viewport when navigating with n or {.
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "{", "{zz")

-- get to the middle viewport when going to the end of buffer.
vim.keymap.set("n", "G", "Gzz")

-- delete the whole line without removing the line space.
vim.keymap.set("n", "dx", "0d$")

-- when indenting/dedenting with visual mode, keep selection.
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

-- 'del' key doesn't delete in normal mode
vim.keymap.set("n", "<Del>", "<nop>")

-- don't select newline character when doing $.
vim.keymap.set("x", "$", "g_")
