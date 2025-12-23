return {
  {
    "nvim-lualine/lualine.nvim",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    opts = require("config.statusline").lualine,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      {
        "echasnovski/mini.bufremove",
        keys = {
          {
            "<leader>bd",
            function()
              require("mini.bufremove").delete(0, false)
            end,
            desc = "Delete Buffer",
          },
          {
            "<leader>bD",
            function()
              require("mini.bufremove").delete(0, true)
            end,
            desc = "Delete Buffer (Force)",
          },
        },
      },
    },
    cond = vim.g.vscode == nil,
    event = "VimEnter",
    keys = {
      { "<leader>tn", "<cmd>BufferLineCycleNext<cr>", desc = "Next Tab" },
      { "<leader>tp", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Tab" },
      { "<leader>tc", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Other Tabs" },
    },
    opts = {
      options = {
        themeable = true,
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
      },
    },
  },
}
