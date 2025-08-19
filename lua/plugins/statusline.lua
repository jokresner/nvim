return {
  "echasnovski/mini.statusline",
  cond = vim.g.vscode == nil,
  event = "VimEnter",
  config = function()
    return require "config.statusline"()
  end,
}
