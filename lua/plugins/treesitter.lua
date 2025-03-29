return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "reasonml-editor/tree-sitter-reason" },
    },
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      require("config.treesitter").setup()
    end,
  },
}
