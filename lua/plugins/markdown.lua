return {
    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        keys = {
            { "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Markdown preview split" },
        },
    },
    { "harukikuri/todoage.nvim", event = "BufReadPost", opts = {} },
}
