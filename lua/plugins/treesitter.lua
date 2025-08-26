return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    lazy = false, -- Does not support lazy loading
    config = function()
      require("config.treesitter").setup()
    end,
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
  },
}
