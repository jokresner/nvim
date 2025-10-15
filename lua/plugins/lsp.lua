return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    cond = vim.g.vscode == nil,
    dependencies = {
      { "folke/lazydev.nvim", ft = "lua" },
      {
        "williamboman/mason.nvim",
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
      "WhoIsSethDaniel/mason-tool-installer.nvim",
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
      {
        "<space>tt",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
        end,
        desc = "Toggle Inlay Hints",
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
}
