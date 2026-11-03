return {
    ft = { "lua" },
    parsers = { "lua", "luadoc" },
    tools = { "stylua", "luacheck" },
    servers = {
        {
            server = "lua_ls",
            config = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        hint = { enable = true },
                    },
                },
            },
        },
    },
    formatters_by_ft = { lua = { "stylua" } },
    linters_by_ft = { lua = { "luacheck" } },
}
