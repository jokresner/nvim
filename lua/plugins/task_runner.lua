return {
    {
        "stevearc/overseer.nvim",
        opts = {
            strategy = {
                "terminal",
                use_shell = true,
                direction = "horizontal",
                size = 15,
                auto_scroll = true,
            },
        },
        keys = {
            {
                "<leader>or",
                "<cmd>OverseerRun<cr>",
                desc = "Run task",
            },
            {
                "<leader>oo",
                "<cmd>OverseerToggle<cr>",
                desc = "Toggle task window",
            },
            {
                "<leader>oa",
                "<cmd>OverseerTaskAction<cr>",
                desc = "Task action",
            },
        },
    },
}
