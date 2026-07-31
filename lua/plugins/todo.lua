return {
    {
        "IogaMaster/tuxedo.nvim",
        opts = {
            create_todo_file = true,
            width_ratio = 0.95,
            height_ratio = 0.8,
        },
        keys = {
            { "<leader>ct", "<cmd>Tuxedo<cr>", desc = "Tuxedo" },
        },
    },
}
