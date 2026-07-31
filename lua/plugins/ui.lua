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
                            key = "p",
                            desc = "Projects",
                            action = ":lua Snacks.dashboard.pick('projects')",
                        },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
            bigfile = { enabled = true },
            notifier = { enabled = true },
            picker = { enabled = true, ui_select = false },
            quickfile = { enabled = true },
            terminal = { enabled = true },
            words = { enabled = true },
        },
        config = function(_, opts)
            require("snacks").setup(opts)
            local toggle = require("snacks").toggle

            -- ponytail: persist desired defaults, not per-window/buffer snapshots.
            local state_path = vim.fn.stdpath("state") .. "/ui_toggles.json"
            local state = {}
            local ok, lines = pcall(vim.fn.readfile, state_path)
            if ok then
                local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
                if decoded_ok and type(decoded) == "table" then
                    state = decoded
                end
            end

            local function save_state()
                vim.fn.mkdir(vim.fn.fnamemodify(state_path, ":h"), "p")
                vim.fn.writefile({ vim.json.encode(state) }, state_path)
            end

            local function persist(t, lhs)
                local set = t.opts.set
                t.opts.set = function(value)
                    set(value)
                    state[t.opts.id] = value
                    save_state()
                end
                if state[t.opts.id] ~= nil then
                    t:set(state[t.opts.id])
                end
                t:map(lhs)
            end

            local function apply_window_state()
                if state.spell ~= nil then
                    vim.wo.spell = state.spell
                end
                if state.wrap ~= nil then
                    vim.wo.wrap = state.wrap
                end
                if state.line_number ~= nil then
                    vim.wo.number = state.line_number
                    vim.wo.relativenumber = state.line_number and state.relativenumber ~= false or false
                elseif state.relativenumber ~= nil then
                    vim.wo.relativenumber = state.relativenumber
                end
            end

            persist(toggle.option("spell", { name = "Spelling" }), "<leader>us")
            persist(toggle.option("wrap", { name = "Wrap" }), "<leader>uw")
            persist(toggle.option("relativenumber", { name = "Relative number" }), "<leader>uL")
            persist(toggle.line_number(), "<leader>ul")
            persist(toggle.diagnostics(), "<leader>ud")
            persist(toggle({
                id = "diagnostic_virtual_text",
                name = "Diagnostic Virtual Text",
                get = function()
                    return vim.diagnostic.config().virtual_text ~= false
                end,
                set = function(enabled)
                    vim.diagnostic.config({
                        virtual_text = enabled and {
                            severity = { min = vim.diagnostic.severity.WARN },
                        } or false,
                    })
                end,
            }), "<leader>uv")
            persist(toggle.treesitter(), "<leader>uT")
            persist(toggle.inlay_hints(), "<leader>ui")
            persist(toggle.indent(), "<leader>ug")

            apply_window_state()
            vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
                group = vim.api.nvim_create_augroup("persisted_ui_toggles", { clear = true }),
                callback = function(event)
                    apply_window_state()
                    if state.treesitter == false then
                        pcall(vim.treesitter.stop, event.buf)
                    end
                end,
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "persisted_ui_toggles",
                callback = function(event)
                    if state.inlay_hints ~= nil then
                        vim.lsp.inlay_hint.enable(state.inlay_hints, { bufnr = event.buf })
                    end
                end,
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
                { "<leader>s", group = "Search" },
                { "<leader>t", group = "Test" },
                { "<leader>u", group = "UI/Toggle" },
                { "<leader>x", group = "Diagnostics" },
            },
        },
    },
}
