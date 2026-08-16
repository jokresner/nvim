return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "stylua",
                "luacheck",
                "prettier",
                "prettierd",
                "tree-sitter-cli",
            },
        },
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        init = function()
            vim.api.nvim_create_user_command("Format", function()
                require("conform").format({ async = true, lsp_fallback = true })
            end, { desc = "Format current buffer" })
        end,
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                desc = "Format buffer",
            },
        },
        opts = {
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
            formatters_by_ft = {
                lua = { "stylua" },
                json = { "jq" },
                yaml = { "prettierd", "prettier" },
                markdown = { "prettierd", "prettier" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile", "BufWritePost" },
        opts = { linters_by_ft = { lua = { "luacheck" } } },
        config = function(_, opts)
            local lint = require("lint")
            lint.linters_by_ft = opts.linters_by_ft

            local timer = vim.uv.new_timer()
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
                callback = function()
                    timer:start(
                        120,
                        0,
                        vim.schedule_wrap(function()
                            lint.try_lint()
                        end)
                    )
                end,
            })
            vim.api.nvim_create_autocmd("VimLeavePre", {
                group = vim.api.nvim_create_augroup("nvim_lint_cleanup", { clear = true }),
                callback = function()
                    pcall(timer.stop, timer)
                    pcall(timer.close, timer)
                end,
            })
        end,
    },
}
