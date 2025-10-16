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
    "nvim-mini/mini.tabline",
    cond = vim.g.vscode == nil,
    event = "VimEnter",
    opts = {
      show_icons = true,
    },
    keys = {
      { "<leader>tn", vim.cmd.tabnext, desc = "Next Tab" },
      { "<leader>tp", vim.cmd.tabprevious, desc = "Previous Tab" },
      { "<leader>tc", vim.cmd.tabnew, desc = "New Tab" },
      { "<leader>tx", vim.cmd.tabclose, desc = "Close Tab" },
      { "<leader>to", vim.cmd.tabonly, desc = "Close Other Tabs" },
    },
  },
}
