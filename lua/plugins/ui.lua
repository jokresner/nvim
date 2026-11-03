-- Add an agent here; keymaps (<leader>a<key>) and the edgy view are generated from it.
local ai_agents = {
    { id = "hx", cmd = "hx", key = "a", title = "Hx" },
    { id = "pi", cmd = "pi", key = "p", title = "Pi" },
}

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            {
                "<leader>ut",
                function()
                    Snacks.terminal()
                end,
                desc = "Terminal",
            },
            {
                "<leader>uc",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Colorscheme switcher",
            },
            {
                "<leader>bd",
                function()
                    Snacks.bufdelete()
                end,
                desc = "Buffer delete",
            },
            {
                "<leader>bD",
                function()
                    Snacks.bufdelete({ force = true })
                end,
                desc = "Buffer delete force",
            },
            {
                "<leader>bo",
                function()
                    Snacks.bufdelete.other()
                end,
                desc = "Buffer delete others",
            },
            {
                "<leader>cn",
                function()
                    Snacks.words.jump(vim.v.count1)
                end,
                mode = { "n", "t" },
                desc = "Code next reference",
            },
            {
                "<leader>cp",
                function()
                    Snacks.words.jump(-vim.v.count1)
                end,
                mode = { "n", "t" },
                desc = "Code prev reference",
            },
        },
        opts = {
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
     __        __                                               
    |__| ____ |  | _________   ____   ______ ____   ___________ 
    |  |/  _ \|  |/ /\_  __ \_/ __ \ /  ___//    \_/ __ \_  __ \
    |  (  <_> )    <  |  | \/\  ___/ \___ \|   |  \  ___/|  | \/
/\__|  |\____/|__|_ \ |__|    \___  >____  >___|  /\___  >__|   
\______|           \/             \/     \/     \/     \/       
]],
                    keys = {
                        {
                            icon = " ",
                            key = "f",
                            desc = "Find file",
                            action = ":lua Snacks.dashboard.pick('smart')",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent files",
                            action = ":lua Snacks.dashboard.pick('recent')",
                        },
                        {
                            icon = " ",
                            key = "w",
                            desc = "Find word",
                            action = ":lua Snacks.dashboard.pick('grep_word')",
                        },
                        { icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.dashboard.pick('grep')" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        {
                            icon = " ",
                            key = "s",
                            desc = "Restore session",
                            action = ":lua require('persistence').load()",
                        },
                        {
                            icon = " ",
                            key = "p",
                            desc = "Projects",
                            action = ":lua Snacks.dashboard.pick('projects')",
                        },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
            bigfile = { enabled = true },
            image = { enabled = true },
            statuscolumn = { enabled = true },
            notifier = { enabled = true },
            picker = { enabled = true, ui_select = false },
            quickfile = { enabled = true },
            terminal = { enabled = true },
            words = { enabled = true },
        },
        config = function(_, opts)
            require("snacks").setup(opts)
            require("core.ai_terminal")
                .new({
                    agents = ai_agents,
                    terminal = function(cmd, terminal_opts)
                        return Snacks.terminal(cmd, terminal_opts)
                    end,
                })
                .map_keys()
            require("core.ui_state").setup({
                path = vim.fn.stdpath("state") .. "/ui_toggles.json",
                toggle = require("snacks").toggle,
            })
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            {
                "<leader>un",
                function()
                    require("noice").cmd("dismiss")
                end,
                desc = "Dismiss notifications",
            },
            {
                "<leader>uN",
                function()
                    require("noice").cmd("all")
                end,
                desc = "Show notifications",
            },
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
        },
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = { input = { default_prompt = ">" } },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>a", group = "AI" },
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code" },
                { "<leader>d", group = "Debug" },
                { "<leader>f", group = "Files" },
                { "<leader>g", group = "Git" },
                { "<leader>m", group = "Markdown" },
                { "<leader>o", group = "Overseer (Tasks)" },
                { "<leader>q", group = "Session" },
                { "<leader>r", group = "Request (HTTP)" },
                { "<leader>s", group = "Search" },
                { "<leader>t", group = "Test" },
                { "<leader>u", group = "UI/Toggle" },
                { "<leader>x", group = "Diagnostics" },
            },
        },
    },
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        init = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = "screen"
        end,
        opts = {
            bottom = {
                { ft = "qf", title = "QuickFix" },
                { ft = "help", size = { height = 20 }, filter = function(buf) return vim.bo[buf].buftype == "help" end },
                { ft = "neotest-output-panel", size = { height = 15 } },
                { title = "Trouble", ft = "trouble", size = { height = 15 } },
            },
            right = require("core.ai_terminal").edgy_views(ai_agents),
            left = {
                { title = "Symbols", ft = "snacks_picker", filter = function(buf) return vim.b[buf].snacks_picker_id == "lsp_symbols" end, size = { width = 0.2 } },
                { title = "Neotest Summary", ft = "neotest-summary", size = { width = 0.2 } },
            },
            options = {
                left = { size = 30 },
                bottom = { size = 15 },
                right = { size = 40 },
            },
            animate = { enabled = false },
        },
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
        },
    },
    {
        "chrisgrieser/nvim-early-retirement",
        config = true,
        event = "VeryLazy",
        opts = {
            retirementClockMins = 20,
            ignoreUnsavedChangesBufs = true,
        },
    },
}
