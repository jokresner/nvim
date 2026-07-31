return {
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
