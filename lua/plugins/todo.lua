return {
    {
        "atiladefreitas/dooing",
        keys = {
            { "<leader>cT", "<cmd>Dooing<cr>", desc = "Dooing" },
            { "<leader>ct", "<cmd>DooingLocal<cr>", desc = "Dooing Project" },
        },
        config = function()
            require("dooing").setup({
                ui = {
                    style = "modern",
                },
                per_project = {
                    enabled = true,
                },
            })
        end,
    },
}
