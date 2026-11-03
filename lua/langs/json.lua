return {
    ft = { "json" },
    parsers = { "json" },
    external = { "jq" }, -- nix
    servers = {
        {
            server = "jsonls",
            config = function()
                return {
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true },
                        },
                    },
                }
            end,
        },
    },
    formatters_by_ft = { json = { "jq" } },
}
