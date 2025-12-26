return {
  {
    "saghen/blink.cmp",
    dependencies = {
      { "yus-works/csc.nvim", opts = {} },
    },
    version = "1.*",
    cond = vim.g.vscode == nil,
    event = "VeryLazy",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = function()
      return require "config.blink"
    end,
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
    "folke/sidekick.nvim",
    event = "VeryLazy",
    cond = vim.g.vscode == nil,
    dependencies = {
      {
        "ravitemer/mcphub.nvim",
        build = "pnpm i -g mcp-hub@latest",
        opts = function()
          return require("config.assistant").mcphub
        end,
      },
    },
    opts = function()
      return require("config.assistant").sidekick
    end,
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send { msg = "{this}" }
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send { msg = "{file}" }
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send { msg = "{selection}" }
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle { name = "cursor", focus = true }
        end,
        desc = "Sidekick Toggle Cursor",
      },
    },
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
    enabled = false,
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
  {
    "Davidyz/VectorCode",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
    config = function()
      require("vectorcode").setup {
        async_opts = {
          events = { "BufWritePost", "InsertEnter", "BufReadPost" },
        },
      }
    end,
  },
}
