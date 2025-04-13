return {
  "folke/todo-comments.nvim",
  vscode = false,
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
}
