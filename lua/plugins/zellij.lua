return {
  "swaits/zellij-nav.nvim",
  cond = vim.g.vscode == nil,
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<leader>zh", "<cmd>ZellijNavigateLeftTab<cr>", { silent = true, desc = "Zellij left/tab" } },
    { "<leader>zj", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Zellij down" } },
    { "<leader>zk", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Zellij up" } },
    { "<leader>zl", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "Zellij right/tab" } },
  },
}
