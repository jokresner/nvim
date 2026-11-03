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
                local lib = vim.fn.has("mac") == 1 and "liblldb.dylib" or "liblldb.so"
                local library_path = package_path .. "/extension/lldb/lib/" .. lib
                opts.dap = {
                    adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
                }
            end
        end
        return opts
    end
end

return {
    ft = { "rust" },
    parsers = { "rust" },
    tools = { "codelldb" },
    external = { "rustfmt", "bacon" }, -- rustup, nix
    servers = {
        -- rustaceanvim starts rust-analyzer itself; the record only carries attach keys.
        {
            server = "rust_analyzer",
            client = "rust-analyzer",
            adapter = "rustaceanvim",
            keys = {
                {
                    "<leader>ca",
                    function()
                        vim.cmd.RustLsp("codeAction")
                    end,
                    desc = "Code action (Rust)",
                },
                {
                    "<leader>dd",
                    function()
                        vim.cmd.RustLsp("debuggables")
                    end,
                    desc = "Rust debuggables",
                },
            },
        },
    },
    formatters_by_ft = { rust = { "rustfmt" } },
    linters_by_ft = { rust = { "bacon" } },
    plugins = {
        {
            "mrcjkb/rustaceanvim",
            version = "^5",
            ft = { "rust" },
            init = configure_rustaceanvim,
        },
    },
}
