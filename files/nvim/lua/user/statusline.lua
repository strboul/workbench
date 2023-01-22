-- single statusline at the bottom.
vim.o.laststatus = 3

-- custom statusline.

local function filename()
  local fname = vim.fn.expand("%")
  if fname == "" then
    return ""
  end
  return fname
end

local function filetype()
  return vim.bo.filetype
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

local function dir()
  local host_pwd = vim.loop.os_environ()["host_PWD"]
  local host_user = vim.loop.os_environ()["host_USER"]
  local dir = string.gsub(host_pwd, table.concat({ "/home/", host_user }), "~")
  return vim.fn.fnamemodify(dir, ":t")
end

local function gitbranch()
  local head = vim.fn.FugitiveHead()
  if head == "" then
    return ""
  end
  local symbol = vim.fn.nr2char(0x2387) -- ALTERNATIVE KEY SYMBOL
  return table.concat({ " ", symbol, " ", head, " " })
end

local function readonly()
  if vim.bo.readonly then
    return "[RO]"
  end
  return ""
end

local function statusline()
  return table.concat({
    "%#Statusline#",
    " ",
    dir(),
    " ",
    gitbranch(),
    "%=",
    filename(),
    "%#WarningMsg#",
    readonly(),
    "%#StatuslineExtra#",
    "%=",
    filetype(),
    lineinfo(),
  })
end

function _G.nvim_statusline()
  return statusline()
end

vim.o.statusline = "%!v:lua.nvim_statusline()"
