return {
  {
    "nvim-mini/mini.sessions",
    version = false,
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    config = function()
      require("mini.sessions").setup()
    end,
    keys = {
      {
        "<leader>qs",
        function()
          require("mini.sessions").read(nil, { force = true })
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("mini.sessions").select()
        end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function()
          require("mini.sessions").read(vim.v.this_session or nil, { force = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("mini.sessions").write("", { force = true })
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
  {
    "alex-popov-tech/store.nvim",
    cond = vim.g.vscode == nil,
    dependencies = { "OXY2DEV/markview.nvim" },
    cmd = "Store",
  },
  {
    "vimichael/floatingtodo.nvim",
    cond = vim.g.vscode == nil,
    keys = {
      { "<leader>td", ":Td<CR>", desc = "Open Floating Todo" },
    },
    opts = function()
      return require("config.tools").floatingtodo
    end,
  },
  {
    "ten3roberts/qf.nvim",
    ft = "qf",
    cond = vim.g.vscode == nil,
    config = function()
      require("qf").setup {}
    end,
  },
  {
    "nvim-mini/mini.operators",
    version = false,
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    config = function()
      require("mini.operators").setup()
    end,
  },
  {
    "beauwilliams/focus.nvim",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
  },
}
