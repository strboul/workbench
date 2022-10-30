Utils = {}

-- Set
-- http://www.lua.org/pil/11.5.html
function Utils.set(list)
  local set = {}
  for _, l in ipairs(list) do
    set[l] = true
  end
  return set
end

return Utils
