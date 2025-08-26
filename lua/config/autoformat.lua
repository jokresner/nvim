local setup = function()
  -- Autoformatting Setup
  local conform = require "conform"
  conform.setup {
    format_on_save = {
      pattern = "*",
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      go = { "gofumpt", "gofmt" },
      json = { "jq" },
      yaml = { "prettierd", "prettier" },
    },
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
    callback = function(args)
      require("conform").format {
        bufnr = args.buf,
        lsp_fallback = true,
        quiet = true,
      }
    end,
  })
end

setup()

return { setup = setup }
