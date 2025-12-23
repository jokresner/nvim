return {
  {
    "nvim-mini/mini.diff",
    version = false,
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    opts = {},
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
    enabled = false,
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
    "esmuellert/vscode-diff.nvim",
    branch = "next",
    dependencies = { "MunifTanjim/nui.nvim" },
    cond = vim.g.vscode == nil,
    keys = {
      {
        "<leader>hs",
        function()
          require("config.vcs").git_pickaxe { global = false }
        end,
        desc = "Git Search Buffer (VSCode Diff)",
      },
      {
        "<leader>hS",
        function()
          require("config.vcs").git_pickaxe { global = true }
        end,
        desc = "Git Search Global (VSCode Diff)",
      },
    },
  },
}
