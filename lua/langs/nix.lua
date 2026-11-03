return {
    ft = { "nix" },
    parsers = { "nix" },
    external = { "nixfmt" }, -- nix
    servers = {
        {
            server = "nixd",
            ensure = false, -- installed by nix
            config = {
                settings = {
                    formatting = { command = { "nixfmt" } },
                },
            },
        },
    },
    formatters_by_ft = { nix = { "nixfmt" } },
}
