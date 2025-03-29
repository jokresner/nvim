return {
  {
    enabled = true,
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    dependencies = {
      "stevearc/dressing.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
          "MeanderingProgrammer/render-markdown.nvim",
          opts = { file_types = { "Avante", "markdown" } },
          ft = { "Avante", "markdown" },
      },
    },
    config = function()
      require("avante").setup {
        hints = { enabled = false },
      }
    end,
  },
}
