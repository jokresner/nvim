return {
  "stevearc/overseer.nvim",
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
  vscode = false,
  opts = {
    dap = false,
    task_list = {
      bindings = {
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
      },
    },
    form = {
      win_opts = {
        winblend = 0,
      },
    },
    confirm = {
      win_opts = {
        winblend = 0,
      },
    },
    task_win = {
      win_opts = {
        winblend = 0,
      },
    },
  },
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
