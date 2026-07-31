return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = { "goimports", "gofumpt", "golangci-lint" } },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "go",
                group = vim.api.nvim_create_augroup("go_options", { clear = true }),
                callback = function()
                    vim.opt_local.expandtab = false
                    vim.opt_local.tabstop = 4
                    vim.opt_local.shiftwidth = 4
                end,
            })
        end,
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.go = { "gofumpt", "goimports", "gofmt" }
        end,
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}
            opts.linters_by_ft.go = { "golangcilint" }
        end,
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "nvim-neotest/neotest-go" },
        opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, require("neotest-go"))
        end,
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = { "leoluz/nvim-dap-go" },
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "delve")
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, function()
                require("dap-go").setup()
            end)
        end,
    },
}
