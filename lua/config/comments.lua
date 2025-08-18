local M = {}

M.setup = function()
  local ok, comment = pcall(require, "Comment")
  if not ok then return end

  comment.setup({
    pre_hook = function(ctx)
      local ok_utils, U = pcall(require, "Comment.utils")
      if not ok_utils then return end
      local location
      if ctx.ctype == U.ctype.line then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.ctype == U.ctype.block then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end
      return require("ts_context_commentstring.internal").calculate_commentstring({
        key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
        location = location,
      })
    end,
  })
end

return M


