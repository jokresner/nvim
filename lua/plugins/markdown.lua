return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "quarto", "rmd", "typst" },
    opts = {
      split_nav = {
        enable = true,
        split_type = "vertical",
        split_size = "50%",
      },
    },
    keys = {
      { "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Markdown Preview (Split)" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
