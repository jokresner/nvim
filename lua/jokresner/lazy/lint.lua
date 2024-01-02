return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    opts = {
      events = { "BufWritePost", "BurReadPost", "InsertLeave" },
    },
    config = function()
      require("lint").opts = opts
    end,
  },
}
