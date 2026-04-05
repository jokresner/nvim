return {
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    keys = {
      {
        "<leader>ca",
        function()
          vim.cmd.RustLsp "codeAction"
        end,
        desc = "Code Action (Rust)",
        ft = "rust",
      },
      {
        "<leader>dd",
        function()
          vim.cmd.RustLsp "debuggables"
        end,
        desc = "Rust debuggables",
        ft = "rust",
      },
    },
    opts = function()
      return require("config.rust").opts
    end,
    config = function(_, opts)
      opts = require("config.rust").configure_dap(opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
        if vim.fn.executable "rust-analyzer" == 0 then
          vim.health.error(
            "rust-analyzer not found in PATH. Install from https://rust-analyzer.github.io/",
            { title = "rustaceanvim" }
          )
        end
      end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    ---@module "gopher"
    ---@type gopher.Config
    opts = {},
  },
  {
    "letieu/jira.nvim",
    cmd = { "Jira" },
    keys = {
      { "<leader>jb", "<cmd>Jira<cr>", desc = "Jira board" },
    },
  },
}
