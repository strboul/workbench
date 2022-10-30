-- single statusline at the bottom.
vim.o.laststatus = 3

-- custom statusline.

local function filename()
  local fname = vim.fn.expand("%")
  if fname == "" then
    return ""
  end
  return table.concat({ " ", fname })
end

local function filemodified()
  if vim.bo.modified then
    return "[+]"
  end
  return ""
end

local function filetype()
  return string.format(" %s ", vim.bo.filetype)
end

local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  if vim.api.nvim_buf_get_name(0) == "" then
    return ""
  end
  return " %l:%c "
end

local function gitbranch()
  local head = vim.fn.FugitiveHead()
  if head == "" then
    return ""
  end
  local symbol = vim.fn.nr2char(0x2387)
  return table.concat({ " ", symbol, " ", head, " " })
end

local function statusline()
  return table.concat({
    "%#Statusline#",
    gitbranch(),
    "%=",
    filename(),
    filemodified(),
    "%=%#StatusLineExtra#",
    filetype(),
    lineinfo(),
  })
end

function _G.nvim_statusline()
  return statusline()
end

vim.o.statusline = "%!v:lua.nvim_statusline()"
