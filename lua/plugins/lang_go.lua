return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = { "goimports", "gofumpt", "golangci-lint" } },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "go",
                group = vim.api.nvim_create_augroup("go_options", { clear = true }),
                callback = function()
                    vim.opt_local.expandtab = false
                    vim.opt_local.tabstop = 4
                    vim.opt_local.shiftwidth = 4
                end,
            })
        end,
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.go = { "gofumpt", "goimports", "gofmt" }
        end,
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}
            opts.linters_by_ft.go = { "golangcilint" }
        end,
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "nvim-neotest/neotest-go" },
        opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, require("neotest-go"))
        end,
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = { "leoluz/nvim-dap-go" },
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "delve")
            opts.adapters = opts.adapters or {}
            table.insert(opts.adapters, function()
                require("dap-go").setup()
            end)
        end,
    },
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
}
