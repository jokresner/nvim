return {
  {
    "danymat/neogen",
    cond = vim.g.vscode == nil,
    opts = function()
      return require("config.neogen")
    end,
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
