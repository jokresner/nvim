return {
  "cbochs/grapple.nvim",
  cond = vim.g.vscode == nil,
  config = function()
    local set = vim.keymap.set
    local grapple = require "grapple"

    set("n", "<leader>h", grapple.toggle, { desc = "Toggle Grapple" })
    set("n", "<leader>H", grapple.toggle_tags, { desc = "Toggle Grapple Tags" })
  end,
}
