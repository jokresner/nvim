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
end

setup()

return { setup = setup }
