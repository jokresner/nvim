return {
  { -- Unison
    "unisonweb/unison",
    branch = "trunk",
    cond = vim.g.vscode == nil,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/editor-support/vim")
      require("lazy.core.loader").packadd(plugin.dir .. "/editor-support/vim")
    end,
    init = function(plugin)
      require("lazy.core.loader").ftdetect(plugin.dir .. "/editor-support/vim")
    end,
  },
  { -- Rust
    "mrcjkb/rustaceanvim",
    version = vim.fn.has "nvim-0.10.0" == 0 and "^4" or false,
    ft = { "rust" },
    cond = vim.g.vscode == nil,
    dependencies = {
      "williamboman/mason.nvim",
    },
    keys = {
      {
        "<leader>cR",
        function()
          vim.cmd.RustLsp "codeAction"
        end,
        desc = "Code Action (Rust)",
        ft = "rust",
      },
      {
        "<leader>dr",
        function()
          vim.cmd.RustLsp "debuggables"
        end,
        desc = "Rust Debuggables",
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
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          { title = "rustaceanvim" }
        )
      end
    end,
  },
  { -- TypeScript Error Translator
    "dmmulroy/ts-error-translator.nvim",
  },
}
