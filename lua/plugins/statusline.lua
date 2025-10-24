return {
  {
    "nvim-mini/mini.statusline",
    cond = vim.g.vscode == nil,
    event = "VimEnter",
    config = function()
      return require "config.statusline"()
    end,
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
      { "<leader>tn", vim.cmd.tabnext, desc = "Next Tab" },
      { "<leader>tp", vim.cmd.tabprevious, desc = "Previous Tab" },
      { "<leader>tc", vim.cmd.tabnew, desc = "New Tab" },
      { "<leader>tx", vim.cmd.tabclose, desc = "Close Tab" },
      { "<leader>to", vim.cmd.tabonly, desc = "Close Other Tabs" },
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
