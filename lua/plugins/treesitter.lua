return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "reasonml-editor/tree-sitter-reason" },
    },
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    vscode = true,
    config = function()
      require("config.treesitter").setup()
    end,
  },
}
