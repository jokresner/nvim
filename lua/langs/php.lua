local function find_mago_config(filename)
    local configs = vim.fs.find(function(name)
        local extension = name:match("%.([^.]+)$")
        return name:lower():find("mago", 1, true) and vim.tbl_contains({ "toml", "yaml", "yml", "json" }, extension)
    end, { path = filename, upward = true })

    return configs[1]
end

return {
    ft = { "php" },
    parsers = { "php" },
    tools = { "php-debug-adapter" },
    external = { "mago", "mago_lint" }, -- nix
    servers = {
        {
            server = "intelephense",
            config = {
                settings = {
                    intelephense = {
                        telemetry = { enabled = false },
                    },
                },
            },
        },
    },
    formatters_by_ft = { php = { "mago" } },
    formatters = {
        mago = {
            command = "mago",
            args = function(_, ctx)
                local config = find_mago_config(ctx.filename)
                local args = { "format", "--stdin-input", "--stdin-filepath", "$FILENAME" }

                if config then
                    table.insert(args, 1, config)
                    table.insert(args, 1, "--config")
                end

                return args
            end,
            stdin = true,
        },
    },
    linters_by_ft = { php = { "mago_lint" } },
    test = {
        plugin = "olimorris/neotest-phpunit",
        adapter = function()
            return require("neotest-phpunit")
        end,
    },
    dap = {
        setup = function(dap)
            dap.adapters.php = {
                type = "executable",
                command = "xdebug.sh",
            }
        end,
    },
}
