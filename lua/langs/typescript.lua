local js_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
}

local function per_ft(value)
    local by_ft = {}
    for _, ft in ipairs(js_filetypes) do
        by_ft[ft] = value
    end
    return by_ft
end

return {
    ft = js_filetypes,
    parsers = { "javascript", "typescript", "tsx" },
    parser_for = { javascriptreact = "tsx", typescriptreact = "tsx" },
    tools = { "eslint_d", "js-debug-adapter" },
    external = { "prettierd", "prettier" },
    servers = {
        { server = "vtsls", disable_formatting = true },
    },
    formatters_by_ft = per_ft({ "prettierd", "prettier" }),
    linters_by_ft = per_ft({ "eslint_d" }),
    test = {
        plugin = "marilari88/neotest-vitest",
        adapter = function()
            return require("neotest-vitest")
        end,
    },
    dap = {
        setup = function(dap)
            if not dap.adapters["pwa-node"] then
                dap.adapters["pwa-node"] = {
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
        end,
    },
    plugins = {
        {
            "dmmulroy/ts-error-translator.nvim",
            ft = { "typescript", "typescriptreact" },
            config = true,
        },
    },
}
