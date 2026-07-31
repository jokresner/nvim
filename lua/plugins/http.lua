return {
    {
        "mistweaverco/kulala.nvim",
        keys = {
            {
                "<leader>rr",
                function()
                    require("kulala").run()
                end,
                desc = "Run request",
            },
            {
                "<leader>rt",
                function()
                    require("kulala").toggle_view()
                end,
                desc = "Toggle output",
            },
        },
        opts = {},
    },
}
