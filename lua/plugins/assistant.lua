return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
      "kaiser-Yang/blink-cmp-avante",
      { 'yus-works/csc.nvim', opts = {} },
    },
    version = "1.*",
    cond = vim.g.vscode == nil,
    event = "InsertEnter",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = function()
      return require "config.blink"
    end,
    opts_extend = { "sources.default" },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    vscode = false,
    cond = vim.g.vscode == nil,
    opts = function()
      return require "config.copilot"
    end,
  },
  {
    "yetone/avante.nvim",
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Avante Ask" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = { "n", "v" }, desc = "Avante Edit" },
      { "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Avante Refresh" },
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante Toggle" },
    },
    cond = vim.g.vscode == nil,
    version = false,
    opts = function()
      return require("config.avante").opts
    end,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "ravitemer/mcphub.nvim",
        build = "pnpm i -g mcp-hub@latest",
        opts = function()
          return require("config.avante").mcphub
        end,
      },
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = function()
          return require("config.avante").img_clip
        end,
      },
      {
        "ellisonleao/glow.nvim",
        ft = { "markdown", "Avante" },
      },
    },
  },
}
