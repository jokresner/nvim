return {
    -- Fast file jumping and grep: fff.
    {
        "dmtrKovalenko/fff.nvim",
        lazy = false,
        build = function()
            require("fff.download").download_or_build_binary()
        end,
        opts = {
            layout = { prompt_position = "top" },
        },
        keys = {
            {
                "<leader><leader>",
                function()
                    require("fff").find_files()
                end,
                desc = "Find files",
            },
        },
    },
    -- File exploration: Yazi.
    {
        "mikavilpas/yazi.nvim",
        lazy = false,
        opts = {
            open_for_directories = true,
            open_multiple_tabs = true,
            keymaps = { show_help = "<f1>" },
        },
        init = function()
            vim.g.loaded_netrwPlugin = 1
        end,
        keys = {
            { "-", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Open yazi" },
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                function()
                    require("flash").jump()
                end,
                mode = { "n", "x", "o" },
                desc = "Flash jump",
            },
            {
                "S",
                function()
                    require("flash").treesitter()
                end,
                mode = { "n", "x", "o" },
                desc = "Flash treesitter",
            },
            {
                "r",
                function()
                    require("flash").remote()
                end,
                mode = "o",
                desc = "Flash remote",
            },
            {
                "R",
                function()
                    require("flash").treesitter_search()
                end,
                mode = { "o", "x" },
                desc = "Flash treesitter search",
            },
            {
                "<C-s>",
                function()
                    require("flash").toggle()
                end,
                mode = "c",
                desc = "Flash toggle search",
            },
        },
    },
    -- Metadata pickers: Snacks.
    {
        "folke/snacks.nvim",
        optional = true,
        keys = {
            {
                "<leader>,",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>xx",
                function()
                    require("snacks").picker.diagnostics()
                end,
                desc = "Diagnostics list",
            },
            {
                "<leader>xb",
                function()
                    require("snacks").picker.diagnostics_buffer()
                end,
                desc = "Buffer diagnostics",
            },
            {
                "<leader>xq",
                function()
                    require("snacks").picker.qflist()
                end,
                desc = "Quickfix list",
            },
            {
                "<leader>xl",
                function()
                    require("snacks").picker.loclist()
                end,
                desc = "Location list",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Find recent",
            },
            {
                "<leader>fp",
                function()
                    Snacks.picker.projects()
                end,
                desc = "Find projects",
            },
            {
                "<leader>sk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Search keymaps",
            },
            {
                "<leader>sh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Search help",
            },
            {
                "<leader>sr",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Search resume",
            },
            {
                "<leader>su",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Search undo history",
            },
            {
                "<leader>sg",
                function()
                    require("fff").live_grep()
                end,
                desc = "Search grep",
            },
            {
                "<leader>sG",
                function()
                    require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
                end,
                desc = "Search fuzzy grep",
            },
            {
                "<leader>sw",
                function()
                    require("fff").live_grep({ query = vim.fn.expand("<cword>") })
                end,
                desc = "Search word",
            },
            {
                "<leader>ss",
                function()
                    Snacks.picker.lsp_symbols()
                end,
                desc = "Search symbols",
            },
            {
                "<leader>sS",
                function()
                    Snacks.picker.lsp_workspace_symbols()
                end,
                desc = "Search workspace symbols",
            },
        },
    },
}
