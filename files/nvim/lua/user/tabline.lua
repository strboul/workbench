-- show tabline if there're more than one tabs
vim.opt.showtabline = 1

-- TODO: optimize this algo

-- Some modifications on the original: https://github.com/mkitt/tabline.vim
--
local function tabline(options)
  local text = ""
  for index = 1, vim.fn.tabpagenr("$") do
    local winnr = vim.fn.tabpagewinnr(index)
    local buflist = vim.fn.tabpagebuflist(index)
    local lenbuflist = #buflist
    local bufnr = buflist[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local bufmodified = vim.fn.getbufvar(bufnr, "&mod")
    local isactivetab = index == vim.fn.tabpagenr()

    text = table.concat({ text, "%", index, "T" })

    if isactivetab then
      text = table.concat({ text, "%#TabLineSel#" })
    end

    if bufname ~= "" then
      -- padding left
      text = table.concat({ text, " " })
      -- index
      if isactivetab then
        text = table.concat({ text, "%#Title#", index })
      else
        text = table.concat({ text, "%#TabLineFill#", index })
      end
      -- num of buffers
      if lenbuflist > 1 then
        text = table.concat({ text, ":", lenbuflist })
      end
      if isactivetab then
        text = table.concat({ text, "%#TabLineSel#", " " })
      else
        text = table.concat({ text, "%#TabLineFill#", " " })
      end
      -- bufname
      text = table.concat({ text, vim.fn.fnamemodify(bufname, ":t") })
      -- modify indicator
      if bufmodified == 1 then
        text = table.concat({ text, "%#WarningMsg#", "[+]", "%#TabLineFill#" })
      end
      -- padding right
      if not isactivetab then
        text = table.concat({ text, " " })
      end
    else
      text = table.concat({ text, "[No Name] " })
    end
  end

  text = table.concat({ text, "%#TabLine#" })
  return text
end

function _G.nvim_tabline()
  return tabline()
end

vim.o.tabline = "%!v:lua.nvim_tabline()"
