return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.lint").opts
    end,
    config = function()
      require("config.lint").setup()
    end,
  },
}
