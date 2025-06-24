return {
  {
    "folke/todo-comments.nvim",
    cond = vim.g.vscode == nil,
    keys = {
      {
        "<leader>ct",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
      {
        "<leader>cT",
        function()
          Snacks.picker.todo_comments { keywords = { "TODO", "FIX", "FIXME" } }
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    opts = {
      pre_hook = function(ctx)
        local U = require "Comment.utils"
        local location = nil
        if ctx.ctype == U.ctype.line then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.ctype == U.ctype.block then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end
        return require("ts_context_commentstring.internal").calculate_commentstring {
          key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
          location = location,
        }
      end,
    },
  },
}
