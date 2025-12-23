return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    dependencies = {
      --      "nvim-treesitter/nvim-treesitter-textobjects",
      --      "nvim-treesitter/nvim-treesitter-context",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall" },
    config = function()
      require("config.treesitter").setup()
    end,
  },
}
