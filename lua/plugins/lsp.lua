return {
  {
    "noirbizarre/ensure.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        enable = { "lua_ls", "gopls", "vtsls", "jsonls", "yamlls" },
        gopls = {
          settings = {
            gopls = {
              buildFlags = { "-tags=unittest" },
            },
          },
        },
      },
      packages = {
        "stylua",
        "delve",
        "codelldb",
        "golangci-lint",
        "luacheck",
        "ast-grep",
      },
    },
    config = function(_, opts)
      require("ensure").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  { "b0o/SchemaStore.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      require("mason-nvim-dap").setup()
      require("config.lsp").setup()
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    init = function()
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format { async = true, lsp_fallback = true }
      end, { desc = "Format current buffer" })
    end,
    keys = {
      { "<leader>cf", "<cmd>Format<cr>", desc = "Code format" },
    },
    opts = require("config.format").opts,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      require("config.lint").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics list" },
      { "<leader>xX", function() require("snacks").picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
      { "<leader>xq", function() require("snacks").picker.qflist() end, desc = "Quickfix list" },
      { "<leader>xl", function() require("snacks").picker.loclist() end, desc = "Location list" },
    },
  },
}
