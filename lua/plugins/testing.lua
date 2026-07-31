return {
    {
        "nvim-neotest/neotest",
        dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>tn",
                function()
                    require("neotest").run.run()
                end,
                desc = "Test nearest",
            },
            {
                "<leader>tf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Test run file",
            },
            {
                "<leader>ta",
                function()
                    require("neotest").run.run(vim.uv.cwd())
                end,
                desc = "Test run all",
            },
            {
                "<leader>tl",
                function()
                    require("neotest").run.run_last()
                end,
                desc = "Test run last",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Test summary",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({ enter = true, auto_close = true })
                end,
                desc = "Test output",
            },
            {
                "<leader>tO",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Test output panel",
            },
            {
                "<leader>tw",
                function()
                    require("neotest").watch.toggle(vim.fn.expand("%"))
                end,
                desc = "Test watch",
            },
        },
        opts = {
            discovery = { enabled = false, concurrent = 1 },
            running = { concurrent = true },
            summary = { animated = true },
        },
        config = function(_, opts)
            local ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(d)
                        return d.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    end,
                },
            }, ns)
            require("neotest").setup(opts)
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        keys = {
            {
                "<leader>st",
                function()
                    require("snacks").picker.todo_comments()
                end,
                desc = "Search todos",
            },
            {
                "<leader>sT",
                function()
                    require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
                end,
                desc = "Search todos and fixes",
            },
        },
    },
}
