return {
    {
        "nvim-neotest/neotest",
        dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim" },
        -- load early so project-wide discovery has finished before "run all"
        event = "VeryLazy",
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
            discovery = { enabled = true, concurrent = 0 },
            running = { concurrent = true },
            summary = { animated = true },
            consumers = {
                -- LSP-style progress: neotest has no "done" event, so debounce the per-file discovery events
                discovery_progress = function(client)
                    local count, timer = 0, vim.uv.new_timer()
                    local id = "neotest_discovery"
                    client.listeners.discover_positions = function()
                        count = count + 1
                        vim.notify(("Discovering tests… %d files"):format(count), vim.log.levels.INFO, {
                            id = id,
                            title = "Neotest",
                            timeout = false,
                        })
                        timer:stop()
                        timer:start(
                            800,
                            0,
                            vim.schedule_wrap(function()
                                vim.notify(("Discovery done: %d files"):format(count), vim.log.levels.INFO, {
                                    id = id,
                                    title = "Neotest",
                                    timeout = 2000,
                                })
                                count = 0
                            end)
                        )
                    end
                    return {}
                end,
            },
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
