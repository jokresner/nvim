local snippy = require "snippy"

vim.snippet.expand = function(body)
  snippy.expand_snippet(body)
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
  filter = filter or {}
  local dir = filter.direction or 1
  if dir == 1 then
    return snippy.can_expand_or_advance()
  else
    return snippy.can_jump(-1)
  end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
  if direction == 1 then
    if snippy.can_expand_or_advance() then
      snippy.expand_or_advance()
      return true
    end
    return false
  else
    if snippy.can_jump(-1) then
      snippy.previous()
      return true
    end
    return false
  end
end

vim.snippet.stop = function()
  snippy.stop_all()
end
