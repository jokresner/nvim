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
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "marilari88/neotest-vitest" },
        opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, require("neotest-vitest"))
        end,
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "js-debug-adapter")
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, function(dap)
                if not dap.adapters["pwa-node"] then
                    require("dap").adapters["pwa-node"] = {
                        type = "server",
                        host = "localhost",
                        port = "${port}",
                        executable = {
                            command = "node",
                            args = {
                                require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                                    .. "/js-debug/src/dapDebugServer.js",
                                "${port}",
                            },
                        },
                    }
                end
                for _, language in ipairs(js_filetypes) do
                    if not dap.configurations[language] then
                        dap.configurations[language] = {
                            {
                                type = "pwa-node",
                                request = "launch",
                                name = "Launch file",
                                program = "${file}",
                                cwd = "${workspaceFolder}",
                            },
                            {
                                type = "pwa-node",
                                request = "attach",
                                name = "Attach",
                                processId = require("dap.utils").pick_process,
                                cwd = "${workspaceFolder}",
                            },
                        }
                    end
                end
            end)
        end,
    },
}
