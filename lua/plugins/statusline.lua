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
      { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
      { "<leader>bc", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Other Buffers" },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
      { "<leader>bP", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
      { "<leader>bs", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by Extension" },
    },
    opts = function()
      return require("config.statusline").bufferline()
    end,
  },
}
