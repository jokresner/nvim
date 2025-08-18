return {
  "cbochs/grapple.nvim",
  cond = vim.g.vscode == nil,
  keys = {
    {
      "<leader>Y",
      function()
        require("grapple").toggle_tags()
      end,
      desc = "Toggle Grapple Tags",
    },
    {
      "<leader>y",
      function()
        require("grapple").toggle()
      end,
      desc = "Toggle Grapple",
    },
  },
}
