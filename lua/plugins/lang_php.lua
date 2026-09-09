return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = { "intelephense" } },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = function(_, opts)
            opts.formatters = opts.formatters or {}
            opts.formatters.mago = {
                command = "mago",
                args = { "format", "--stdin-input", "--stdin-filepath", "$FILENAME" },
                stdin = true,
            }
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.php = { "mago" }
        end,
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}
            opts.linters_by_ft.php = { "mago_lint" }
        end,
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "olimorris/neotest-phpunit" },
        opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, require("neotest-phpunit"))
        end,
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "php-debug-adapter")
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, function(dap)
                dap.adapters.php = {
                    type = "executable",
                    command = "xdebug.sh",
                }
            end)
        end,
    },
}
