return {
    {
        "folke/sidekick.nvim",
        keys = {
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "AI toggle CLI",
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select()
                end,
                desc = "AI select CLI",
            },
            {
                "<leader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "AI detach CLI",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "AI send file",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "n", "x" },
                desc = "AI send this",
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = "x",
                desc = "AI send selection",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "AI prompt",
            },
            {
                "<leader>ac",
                function()
                    require("sidekick.cli").toggle({ name = "cursor", focus = true })
                end,
                desc = "AI toggle cursor",
            },
        },
        opts = {
            cli = {
                win = {
                    layout = "right",
                    split = { width = 80, height = 20 },
                },
                mux = {
                    enabled = true,
                    backend = "zellij",
                },
            },
        },
    },
}
