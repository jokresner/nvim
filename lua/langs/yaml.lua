return {
    ft = { "yaml" },
    parsers = { "yaml" },
    external = { "prettierd", "prettier" },
    servers = {
        {
            server = "yamlls",
            config = function()
                return {
                    settings = {
                        yaml = {
                            schemas = require("schemastore").yaml.schemas(),
                            keyOrdering = false,
                        },
                    },
                }
            end,
        },
    },
    formatters_by_ft = { yaml = { "prettierd", "prettier" } },
}
