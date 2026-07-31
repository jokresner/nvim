return {
    {
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        build = function()
            require("dbee").install()
        end,
        keys = {
            {
                "<leader>D",
                function()
                    require("dbee").api.ui.toggle()
                end,
                desc = "Database UI",
            },
        },
        config = function(_, opts)
            require("dbee").setup(opts)
        end,
    },
}
