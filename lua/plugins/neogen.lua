return {
  {
    "danymat/neogen",
    cond = vim.g.vscode == nil,
    config = true,
    keys = {
      {
        "<leader>cd",
        function()
          require("neogen").generate()
        end,
        desc = "Generate Documentation",
      },
    },
  },
}
