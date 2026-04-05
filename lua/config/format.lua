local M = {}

M.opts = {
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofumpt", "goimports", "gofmt" },
    rust = { "rustfmt" },
    json = { "jq" },
    yaml = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },
  },
}

return M
