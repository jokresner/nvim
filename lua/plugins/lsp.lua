return {
  {
    "noirbizarre/ensure.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "lua_ls",
        "delve",
        "gopls",
        "golangci-lint",
        "luacheck",
        "codelldb",
        "harper-ls",
        "ast-grep",
        "vtsls",
        "jsonls",
        "yamlls",
      },
      parsers = {
        "lua",
        "go",
        "rust",
        "php",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
        "query",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    cond = vim.g.vscode == nil,
    dependencies = {
      { "folke/lazydev.nvim", ft = "lua" },
      {
        "williamboman/mason.nvim",
        event = "VeryLazy",
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
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      { "j-hui/fidget.nvim", lazy = true },
      "b0o/SchemaStore.nvim",
    },
    keys = {
      {
        "K",
        function()
          vim.lsp.buf.hover()
        end,
        desc = "Hover Documentation",
      },
      {
        "<space>cR",
        function()
          vim.lsp.buf.rename()
        end,
        desc = "Code Rename",
      },
      {
        "<space>ca",
        function()
          vim.lsp.buf.code_action()
        end,
        desc = "Code Action",
      },
      {
        "<space>wd",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "Symbols in current document",
      },
    },
    config = function()
      require("config.lsp").setup()
    end,
  },
  {
    "stevearc/conform.nvim",
    cond = vim.g.vscode == nil,
    event = "BufReadPre",
    init = function()
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format { lsp_fallback = true, async = true }
      end, { desc = "Format current buffer" })
    end,
    config = function()
      require("config.autoformat").setup()
    end,
    keys = {
      {
        "<leader>lf",
        ":Format<CR>",
        desc = "Format code (Conform)",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    },
  },
}
