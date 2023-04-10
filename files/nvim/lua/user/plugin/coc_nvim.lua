-- coc.nvim plugin config
--
-- Adapted from https://github.com/neoclide/coc.nvim#example-lua-configuration
--
-- My modifications are with `Edited(my)`.
--

vim.g.coc_global_extensions = {
  -- "@yaegassy/coc-ansible",
  "@yaegassy/coc-nginx",
  "coc-clangd",
  "coc-cmake",
  "coc-css",
  "coc-deno",
  "coc-eslint",
  "coc-go",
  "coc-highlight",
  "coc-html",
  "coc-json",
  -- "coc-lua", -- doesn't work
  "coc-prettier",
  "coc-pydocstring",
  "coc-pyright",
  "coc-sh",
  "coc-sql",
  "coc-tsserver",
  "coc-vetur",
  "coc-vimlsp",
  "coc-vimtex",
  "coc-xml",
  "coc-yaml",
  "coc-snippets",
}

local keyset = vim.keymap.set

-- Use Tab for trigger completion with characters ahead and navigate
local completion_opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset(
  "i",
  "<TAB>",
  'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
  completion_opts
)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], completion_opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset(
  "i",
  "<cr>",
  [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
  completion_opts
)

function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- GoTo code navigation
-- XXX Edited(my): bring the viewport to the middle of the screen afterwards.
keyset("n", "gd", "<Plug>(coc-definition)zz", { silent = true })

-- Snippets
-- XXX Edited(my): added
-- list snippets.
keyset("n", "<leader>csl", ":CocList snippets", { silent = true, expr = true })

-- Use K to show documentation in preview window
function _G.show_documentation()
  local cw = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command("h " .. cw)
  elseif vim.api.nvim_eval("coc#rpc#ready()") then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
  end
end
keyset("n", "K", "<CMD>lua _G.show_documentation()<CR>", { silent = true })

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
local augroup_coc_nvim = vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = augroup_coc_nvim,
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold",
})

-- Symbol renaming
-- XXX Edited(my): changed keys.
keyset("n", "<leader>cr", "<Plug>(coc-rename)", { silent = true })

-- Use vv for selections ranges
-- XXX Edited(my): changed keys.
-- Requires 'textDocument/selectionRange' support of language server
keyset("n", "vv", "<Plug>(coc-range-select)", { silent = true })
keyset("x", "vv", "<Plug>(coc-range-select)", { silent = true })

-- Mappings for CoCList
-- XXX Edited(my): changed keys.
local coclist_opts = { silent = true, nowait = true }
-- Show all diagnostics
keyset("n", "<leader>ca", ":<C-u>CocList diagnostics<cr>", coclist_opts)
-- Show commands
keyset("n", "<leader>cc", ":<C-u>CocList commands<cr>", coclist_opts)
-- Find symbol of current document
keyset("n", "<leader>co", ":<C-u>CocList outline<cr>", coclist_opts)
-- Search workspace symbols
keyset("n", "<leader>cws", ":<C-u>CocList -I symbols<cr>", coclist_opts)

-- Completion item colors
-- check list in `:h CocSymbol`.
vim.cmd([[ hi! link CocSymbolSnippet CocListBgMagenta ]])
