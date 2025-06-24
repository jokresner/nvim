return {
  "cbochs/grapple.nvim",
  cond = vim.g.vscode == nil,
  config = function()
    local set = vim.keymap.set
    local grapple = require "grapple"

    set("n", "<leader>y", grapple.toggle, { desc = "Toggle Grapple" })
    set("n", "<leader>Y", grapple.toggle_tags, { desc = "Toggle Grapple Tags" })
  end,
}
