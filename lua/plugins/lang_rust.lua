local function configure_rustaceanvim()
    vim.g.rustaceanvim = function()
        local opts = {
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            buildScripts = { enable = true },
                        },
                        checkOnSave = true,
                        diagnostics = { enable = true },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                        files = {
                            excludeDirs = {
                                ".direnv",
                                ".git",
                                ".github",
                                ".gitlab",
                                "bin",
                                "node_modules",
                                "target",
                                "venv",
                                ".venv",
                            },
                        },
                    },
                },
            },
        }
        local ok, registry = pcall(require, "mason-registry")
        if ok and registry.has_package("codelldb") then
            local pkg = registry.get_package("codelldb")
            local package_path = pkg and pkg.get_install_path and pkg:get_install_path()
            if package_path and package_path ~= "" then
                local codelldb = package_path .. "/extension/adapter/codelldb"
                local library_path = package_path .. "/extension/lldb/lib/liblldb.so"
                opts.dap = {
                    adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
                }
            end
        end
        return opts
    end
end

return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = { "bacon", "codelldb" } },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
        init = configure_rustaceanvim,
        config = function()
            local function map_rust_keys(bufnr)
                vim.keymap.set("n", "<leader>ca", function()
                    vim.cmd.RustLsp("codeAction")
                end, { buffer = bufnr, silent = true, desc = "Code action (Rust)" })
                vim.keymap.set("n", "<leader>dd", function()
                    vim.cmd.RustLsp("debuggables")
                end, { buffer = bufnr, silent = true, desc = "Rust debuggables" })
            end

            if vim.bo.filetype == "rust" then
                map_rust_keys(0)
            end
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("rustaceanvim_keymaps", { clear = true }),
                pattern = "rust",
                callback = function(event)
                    map_rust_keys(event.buf)
                end,
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = function(_, opts)
            opts.formatters_by_ft = opts.formatters_by_ft or {}
            opts.formatters_by_ft.rust = { "rustfmt" }
        end,
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = function(_, opts)
            opts.linters_by_ft = opts.linters_by_ft or {}
            opts.linters_by_ft.rust = { "bacon" }
        end,
    },
}
