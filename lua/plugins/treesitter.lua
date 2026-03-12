return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true,
          max_lines = 2,
          multiline_threshold = 1,
          mode = "cursor",
          separator = "─",
        },
      },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall" },
    config = function()
      require("config.treesitter").setup()
    end,
  },
}
