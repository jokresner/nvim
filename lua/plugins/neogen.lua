return {
  {
    "danymat/neogen",
    cond = vim.g.vscode == nil,
    config = true,
    init = function()
      local neogen = require "neogen"

      vim.keymap.set("n", "<leader>cd", neogen.generate, { desc = "Generate Documentation" })
    end,
  },
}
