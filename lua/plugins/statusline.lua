return {
  "echasnovski/mini.statusline",
  cond = vim.g.vscode == nil,
  event = "VimEnter",
  opts = function()
    local statusline = require "mini.statusline"
    statusline.setup { use_icons = vim.g.have_nerd_font }
  end,
}
