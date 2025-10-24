return {
  "stevearc/overseer.nvim",
  version = "v1.6.0",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerClearCache",
  },
  cond = vim.g.vscode == nil,
  opts = function()
    return require "config.tasks"
  end,
  -- stylua: ignore
  keys = {
    { "<leader>xw", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
    { "<leader>xo", "<cmd>OverseerRun<cr>",         desc = "Run task" },
    { "<leader>xq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
    { "<leader>xi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
    { "<leader>xb", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
    { "<leader>xt", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
    { "<leader>xc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
  },
}
