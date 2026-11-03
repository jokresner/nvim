return {
    ft = { "go" },
    parsers = { "go", "gomod", "gosum" },
    tools = { "goimports", "gofumpt", "golangci-lint", "delve" },
    external = { "gofmt" }, -- go toolchain
    servers = {
        {
            server = "gopls",
            config = {
                settings = {
                    gopls = {
                        buildFlags = { "-tags=unittest" },
                        vulncheck = "Imports",
                        codelenses = {
                            gc_details = true,
                            gc_details_all = true,
                            generate = true,
                            regenerate_cgo = true,
                            tidy = true,
                            run_govulncheck = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            },
        },
    },
    formatters_by_ft = { go = { "gofumpt", "goimports", "gofmt" } },
    linters_by_ft = { go = { "golangcilint" } },
    test = {
        plugin = "nvim-neotest/neotest-go",
        adapter = function()
            return require("neotest-go")({ recursive_run = true })
        end,
    },
    dap = {
        plugin = "leoluz/nvim-dap-go",
        setup = function()
            require("dap-go").setup()
        end,
    },
    options = { expandtab = false, tabstop = 4, shiftwidth = 4 },
    plugins = {
        {
            "olexsmir/gopher.nvim",
            ft = "go",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
            keys = {
                { "<leader>cA", "<cmd>GoTestsAll<CR>", desc = "Go: Generate all tests", ft = "go" },
                { "<leader>cC", "<cmd>GoCmt<CR>", desc = "Go: Generate comment", ft = "go" },
                { "<leader>cD", ":GoGet ", desc = "Go: Get dependency", ft = "go" },
                { "<leader>cE", "<cmd>GoTestsExp<CR>", desc = "Go: Generate exported tests", ft = "go" },
                { "<leader>cg", "<cmd>GoGenerate %<CR>", desc = "Go: Generate current file", ft = "go" },
                { "<leader>cI", ":GoImpl ", desc = "Go: Implement interface", ft = "go" },
                { "<leader>cJ", "<cmd>GoJson<CR>", desc = "Go: JSON to Go types", ft = "go" },
                { "<leader>cM", ":GoMod ", desc = "Go: Run module command", ft = "go" },
                { "<leader>cN", "<cmd>GoNew<CR>", desc = "Go: Generate constructor", ft = "go" },
                { "<leader>cP", "<cmd>GoInstallDeps<CR>", desc = "Go: Install dependencies", ft = "go" },
                { "<leader>cR", "<cmd>GoTagRm<CR>", desc = "Go: Remove tags", ft = "go" },
                { "<leader>cS", "<cmd>GoTagAdd json<CR>", desc = "Go: Add JSON tags", ft = "go" },
                { "<leader>cT", "<cmd>GoTestAdd<CR>", desc = "Go: Generate test", ft = "go" },
                { "<leader>cW", "<cmd>GoWork sync<CR>", desc = "Go: Sync workspace", ft = "go" },
                { "<leader>cY", "<cmd>GoTagAdd yaml<CR>", desc = "Go: Add YAML tags", ft = "go" },
                { "<leader>ce", "<cmd>GoIfErr<CR>", desc = "Go: Generate if err", ft = "go" },
                { "<leader>cm", "<cmd>GoMod tidy<CR>", desc = "Go: Tidy module", ft = "go" },
            },
            opts = {},
        },
    },
}
