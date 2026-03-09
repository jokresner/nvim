return {
  {
    "mfussenegger/nvim-dap",
    cond = vim.g.vscode == nil,
    dependencies = {
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
      "igorlfs/nvim-dap-view",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("config.dap").setup()
    end,
  },
}
