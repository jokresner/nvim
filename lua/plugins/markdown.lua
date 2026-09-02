return {
    {
        "OXY2DEV/markview.nvim",
        ft = { "markdown", "quarto", "rmd", "typst" },
        keys = {
            { "<leader>mp", "<cmd>Markview splitToggle<cr>", desc = "Markdown preview split" },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("markview_nowrap", { clear = true }),
                pattern = { "markdown", "quarto", "rmd", "typst" },
                callback = function()
                    vim.opt_local.wrap = false
                end,
            })
        end,
        opts = {
            experimental = {
                prefer_nvim = true,
                file_open_command = "tabnew",
            },
            preview = {
                enable = true,
                enable_hybrid_mode = true,
                filetypes = { "markdown", "quarto", "rmd", "typst" },
                modes = { "n", "no", "i", "c" },
                hybrid_modes = { "i" },
                linewise_hybrid_mode = true,
                edit_range = { 1, 1 },
                icon_provider = "mini",
            },
        },
    },
    {
        "harukikuri/todoage.nvim",
        event = "BufReadPost",
        opts = {},
    },
}
