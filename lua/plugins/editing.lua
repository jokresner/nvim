return {
  {
    "nvim-mini/mini.comment",
    version = false,
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    config = function()
      require("mini.comment").setup()
    end,
  },
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
    opts = function()
      return require("config.editing").todo_comments
    end,
  },
  {
    "nvim-mini/mini.surround",
    version = false,
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.editing").mini_surround
    end,
  },
  {
    "dcampos/nvim-snippy",
    cond = vim.g.vscode == nil,
    event = "InsertEnter",
    config = function()
      require("snippy").setup(require("config.editing").snippy)
      require "config.snippets"
    end,
    keys = {
      {
        "<c-k>",
        function()
          return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
        end,
        mode = { "i", "s" },
        silent = true,
        expr = true,
        desc = "Snippet jump forward",
      },
      {
        "<c-j>",
        function()
          return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
        end,
        mode = { "i", "s" },
        silent = true,
        expr = true,
        desc = "Snippet jump backward",
      },
    },
  },
  {
    "nvim-mini/mini.ai",
    version = false,
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    config = function()
      require("mini.ai").setup(require("config.editing").mini_ai)
    end,
  },
}
