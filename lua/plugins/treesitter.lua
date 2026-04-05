return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true,
          max_lines = 2,
          multiline_threshold = 1,
          mode = "cursor",
          separator = "-",
        },
      },
    },
    config = function()
      require("config.treesitter").setup()
    end,
  },
}
