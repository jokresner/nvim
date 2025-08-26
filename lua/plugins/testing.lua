return {
  {
    "vim-test/vim-test",
    cond = vim.g.vscode == nil,
    keys = {
      { "<leader>mt", ":TestFile\n", desc = "Run File (vim-test)" },
      { "<leader>mr", ":TestNearest\n", desc = "Run Nearest (vim-test)" },
      { "<leader>mT", ":TestSuite\n", desc = "Run Suite (vim-test)" },
      { "<leader>ml", ":TestLast\n", desc = "Run Last (vim-test)" },
      { "<leader>ms", ":TestSuite\n", desc = "Run Suite (vim-test)" },
    },
    init = function()
      local conf = require "config.testing"
      vim.g["test#strategy"] = conf.vim_test.strategy
    end,
  },
}
