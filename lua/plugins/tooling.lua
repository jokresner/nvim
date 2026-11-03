return {
    {
        -- The only install channel: language files add tools and LSP servers
        -- through core.lang (mason-lspconfig maps lspconfig names to packages).
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = { "tree-sitter-cli" } },
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
            {
                "<leader>cF",
                function()
                    vim.b.disable_autoformat = not vim.b.disable_autoformat
                    vim.notify(
                        "Format on save "
                            .. (vim.b.disable_autoformat and "disabled" or "enabled")
                            .. " for this buffer"
                    )
                end,
                desc = "Toggle format on save",
            },
        },
        opts = {
            format_on_save = function(bufnr)
                if vim.b[bufnr].disable_autoformat then
                    return
                end

                return { timeout_ms = 500, lsp_fallback = true }
            end,
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile", "BufWritePost" },
        opts = {},
        config = function(_, opts)
            local lint = require("lint")
            lint.linters_by_ft = opts.linters_by_ft or {}

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
