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
    "nvim-mini/mini.ai",
    version = false,
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    config = function()
      require("mini.ai").setup(require("config.editing").mini_ai)
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files" },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
        desc = "Refactoring",
      },
    },
    opts = {},
  },
}
