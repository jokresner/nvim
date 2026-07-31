return {
    {
        "esmuellert/codediff.nvim",
        cmd = "CodeDiff",
        keys = {
            { "<leader>gd", "<cmd>CodeDiff<CR>", desc = "Git diff status" },
            { "<leader>gm", "<cmd>CodeDiff main...<CR>", desc = "Git diff from main" },
            { "<leader>gM", "<cmd>CodeDiff main<CR>", desc = "Git diff with main" },
            { "<leader>gf", "<cmd>CodeDiff file main... --inline<CR>", desc = "Git file diff from main" },
            { "<leader>gF", "<cmd>CodeDiff file main --inline<CR>", desc = "Git file diff with main" },
            {
                "<leader>gL",
                function()
                    local line = vim.fn.line(".")
                    vim.cmd(("%d,%dCodeDiff history"):format(line, line))
                end,
                desc = "Git current line diff",
            },
        },
    },
    {
        "folke/snacks.nvim",
        optional = true,
        keys = {
            {
                "<leader>gl",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit",
            },
            {
                "<leader>gB",
                function()
                    Snacks.picker.git_branches()
                end,
                desc = "Git branches",
            },
            {
                "<leader>gc",
                function()
                    Snacks.picker.git_log()
                end,
                desc = "Git log (commits)",
            },
            {
                "<leader>gC",
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = "Git log (file)",
            },
            {
                "<leader>gx",
                function()
                    Snacks.picker.git_status()
                end,
                desc = "Git status",
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- QWERTZ-safe hunk navigation: no [ or ]
                map("n", "<leader>h", gs.next_hunk, "Next hunk")
                map("n", "<leader>H", gs.prev_hunk, "Prev hunk")

                -- Hunk operations
                map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
                map("v", "<leader>gs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage hunk (visual)")
                map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
                map("v", "<leader>gr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset hunk (visual)")
                map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle blame")
            end,
        },
    },
}
