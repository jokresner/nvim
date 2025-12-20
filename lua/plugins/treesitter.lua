return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    dependencies = {
      --      "nvim-treesitter/nvim-treesitter-textobjects",
      --      "nvim-treesitter/nvim-treesitter-context",
    },
    lazy = false, -- Does not support lazy loading
    config = function()
      require("config.treesitter").setup()
    end,
  },
}
