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
    keys = {},
  },
}
