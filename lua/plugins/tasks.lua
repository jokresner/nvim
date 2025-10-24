return {
  "stevearc/overseer.nvim",
  version = "v1.6.0",
  cond = vim.g.vscode == nil,
  opts = function()
    return require "config.tasks"
  end,
  -- stylua: ignore
  keys = {
    { "<leader>xw", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
    { "<leader>xo", "<cmd>OverseerRun<cr>",         desc = "Run task" },
    { "<leader>xi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
    { "<leader>xb", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
    { "<leader>xt", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
    { "<leader>xc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
  },
}
