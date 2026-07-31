return {
    {
        "barelief/buftyper.nvim",
        cmd = "BufTyper",
        keys = {
            { "<leader>up", "<cmd>BufTyper<cr>", mode = { "n", "v" }, desc = "Typing practice" },
        },
        opts = {
            show_wpm = true,
            show_mode_indicator = true,
        },
    },
}
