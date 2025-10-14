return {
  {
    "nvim-mini/mini.diff",
    version = false,
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    config = function()
      require("mini.diff").setup()
    end,
    keys = {
      {
        "[h",
        function()
          require("mini.diff").goto_hunk "prev"
        end,
        desc = "Prev Hunk",
      },
      {
        "]h",
        function()
          require("mini.diff").goto_hunk "next"
        end,
        desc = "Next Hunk",
      },
      {
        "[H",
        function()
          require("mini.diff").goto_hunk "first"
        end,
        desc = "First Hunk",
      },
      {
        "]H",
        function()
          require("mini.diff").goto_hunk "last"
        end,
        desc = "Last Hunk",
      },
      -- German layout-friendly aliases
      {
        "<leader>hp",
        function()
          require("mini.diff").goto_hunk "prev"
        end,
        desc = "Prev Hunk (alt)",
      },
      {
        "<leader>hn",
        function()
          require("mini.diff").goto_hunk "next"
        end,
        desc = "Next Hunk (alt)",
      },
      {
        "gh",
        function()
          return require("mini.diff").operator "apply"
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Apply hunk (operator)",
      },
      {
        "gH",
        function()
          return require("mini.diff").operator "reset"
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Reset hunk (operator)",
      },
      {
        "<leader>gO",
        function()
          require("mini.diff").toggle_overlay()
        end,
        desc = "Toggle diff overlay",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose" },
    cond = vim.g.vscode == nil,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    cond = vim.g.vscode == nil,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      integrations = { diffview = true },
    },
    keys = {
      {
        "<leader>gn",
        function()
          require("neogit").open()
        end,
        desc = "Neogit",
      },
    },
  },
  {
    "dnlhc/glance.nvim",
    cond = vim.g.vscode == nil,
    cmd = { "Glance" },
    opts = function()
      return require("config.vcs").glance
    end,
    keys = {
      { "gd", "<cmd>Glance definitions<CR>", desc = "Glance Definitions" },
      { "gr", "<cmd>Glance references<CR>", desc = "Glance References" },
      { "gi", "<cmd>Glance implementations<CR>", desc = "Glance Implementations" },
      { "gt", "<cmd>Glance type_definitions<CR>", desc = "Glance Type Defs" },
    },
  },
}
