return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "BufReadPre", "BufNewFile", "CmdlineEnter" },
    opts = function()
      return require("config.completion")
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        keymap = {
          accept = false,
          next = "<C-j>",
          prev = "<C-p>",
        },
      },
      panel = { enabled = false },
      filetypes = { markdown = true, help = true },
      server_opts_overrides = { settings = { telemetry = { telemetryLevel = "off" } } },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      disable_inline_completion = false,
      disable_keymaps = true,
      ignore_filetypes = { cpp = true },
      log_level = "warn",
    },
  },
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "ravitemer/mcphub.nvim",
        build = "pnpm i -g mcp-hub@latest",
        opts = {
          extensions = {
            sidekick = { make_slash_commands = true },
          },
        },
      },
    },
    opts = {
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
    keys = {
      { "<C-.>", function() require("sidekick.cli").toggle() end, mode = { "n", "i", "x", "t" }, desc = "AI toggle" },
      { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "AI toggle CLI" },
      { "<leader>as", function() require("sidekick.cli").select() end, desc = "AI select CLI" },
      { "<leader>ad", function() require("sidekick.cli").close() end, desc = "AI detach CLI" },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "AI send file" },
      { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, mode = { "n", "x" }, desc = "AI send this" },
      { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, mode = "x", desc = "AI send selection" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "AI prompt" },
      { "<leader>ac", function() require("sidekick.cli").toggle({ name = "cursor", focus = true }) end, desc = "AI toggle cursor" },
    },
  },
  {
    "Davidyz/VectorCode",
    version = "*",
    build = "uv tool upgrade vectorcode",
    event = "VeryLazy",
    opts = {
      async_opts = {
        events = { "BufWritePost", "InsertEnter", "BufReadPost" },
      },
    },
    keys = {
      { "<leader>aV", function() require("vectorcode") end, desc = "AI load VectorCode" },
    },
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    opts = { snippet_engine = "nvim" },
    keys = {
      { "<leader>cD", function() require("neogen").generate() end, desc = "Code docs generate" },
    },
  },
}
