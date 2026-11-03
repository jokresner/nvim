return {
    ft = { "markdown" },
    parsers = { "markdown", "markdown_inline" },
    external = { "prettierd", "prettier" },
    formatters_by_ft = { markdown = { "prettierd", "prettier" } },
}
