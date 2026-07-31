local js_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
}

return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = { "eslint_d" } },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            for _, ft in ipairs(js_filetypes) do
                opts.formatters_by_ft[ft] = { "prettierd", "prettier" }
            end
        end,
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}
            for _, ft in ipairs(js_filetypes) do
                opts.linters_by_ft[ft] = { "eslint_d" }
            end
        end,
    },
    {
        "dmmulroy/ts-error-translator.nvim",
        ft = { "typescript", "typescriptreact" },
        config = true,
    },
}
