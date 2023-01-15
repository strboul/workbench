local function qf_statusline()
  local statusline = "%f %L lines%="
  if vim.w.quickfix_title ~= nil then
    local qf_title = table.concat({
      " ",
      vim.fn.nr2char(0x00AB), -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
      " ",
      vim.w.quickfix_title,
      " ",
      vim.fn.nr2char(0x00BB), -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
      " ",
    })
    statusline = table.concat({ statusline, qf_title })
  end
  return statusline
end

local augroup_quickfix = vim.api.nvim_create_augroup("Quickfix", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "quickfix window",
  group = augroup_quickfix,
  pattern = "quickfix",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.list = false
    vim.opt_local.colorcolumn = ""
    -- easy close.
    vim.keymap.set("n", "<ESC>", ":cclose<CR>")
    -- statusline.
    vim.opt_local.statusline = qf_statusline()
  end,
})
