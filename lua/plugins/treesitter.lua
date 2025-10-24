return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    lazy = false, -- Does not support lazy loading
    config = function()
      require("config.treesitter").setup()
    end,
  },
}
