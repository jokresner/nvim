return {
  {
    "stevearc/oil.nvim",
    cond = vim.g.vscode == nil,
    lazy = false,
    opts = {},
    keys = {
      { "<leader>-", "<cmd>Oil<cr>", desc = "Open Oil at the current file" },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    cond = vim.g.vscode == nil,
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      { "-", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
    },
    ---@type YaziConfig | {}
    opts = function()
      return require("config.navigation").yazi
    end,
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "nvim-mini/mini.visits",
    version = false,
    cond = vim.g.vscode == nil,
    config = function()
      require("mini.visits").setup()
    end,
    keys = {
      {
        "<leader>vy",
        function()
          require("mini.visits").add_label "core"
        end,
        desc = "Visits: add 'core' label",
      },
      {
        "<leader>vd",
        function()
          require("mini.visits").delete_label "core"
        end,
      },
      {
        "<leader>vY",
        function()
          require("mini.visits").select_path(nil, { filter = "core" })
        end,
        desc = "Visits: select 'core' (cwd)",
      },
      {
        "<leader>v1",
        function()
          require("mini.visits").iterate_paths("first", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits first",
      },
      {
        "<leader>v2",
        function()
          require("mini.visits").iterate_paths("backward", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits backward",
      },
      {
        "<leader>v3",
        function()
          require("mini.visits").iterate_paths("forward", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits forward",
      },
      {
        "<leader>v4",
        function()
          require("mini.visits").iterate_paths("last", vim.fn.getcwd(), { filter = "core", wrap = true })
        end,
        desc = "Visits last",
      },
    },
  },
}
