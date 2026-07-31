local function setup_lsp_keymaps()
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
        callback = function(event)
            local base_opts = { buffer = event.buf, silent = true }
            local ok_snacks, snacks = pcall(require, "snacks")

            local function map(lhs, rhs, desc, extra_opts)
                vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", base_opts, extra_opts or {}, { desc = desc }))
            end

            local function picker(method, fallback)
                return function()
                    if ok_snacks and snacks.picker and snacks.picker[method] then
                        snacks.picker[method]()
                        return
                    end
                    fallback()
                end
            end

            map("K", vim.lsp.buf.hover, "LSP hover")
            map("gd", picker("lsp_definitions", vim.lsp.buf.definition), "Go to definition")
            map("gD", picker("lsp_declarations", vim.lsp.buf.declaration), "Go to declaration")
            map("gI", picker("lsp_implementations", vim.lsp.buf.implementation), "Go to implementation")
            map("gR", picker("lsp_references", vim.lsp.buf.references), "Go to references")
            map("gr", picker("lsp_references", vim.lsp.buf.references), "Go to references", { nowait = true })
            map("gy", picker("lsp_type_definitions", vim.lsp.buf.type_definition), "Go to type definition")
            map("gai", function()
                if ok_snacks and snacks.picker then
                    snacks.picker.lsp_incoming_calls()
                end
            end, "Incoming calls")
            map("gao", function()
                if ok_snacks and snacks.picker then
                    snacks.picker.lsp_outgoing_calls()
                end
            end, "Outgoing calls")
            map("<leader>ca", vim.lsp.buf.code_action, "Code action")
            map("<leader>cr", vim.lsp.buf.rename, "Code rename")
        end,
    })
end

return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "b0o/SchemaStore.nvim",
        },
        config = function()
            setup_lsp_keymaps()
            require("core.lsp_engine").setup({
                servers = {
                    {
                        server = "lua_ls",
                        config = {
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    hint = { enable = true },
                                },
                            },
                        },
                    },
                    {
                        server = "jsonls",
                        config = function()
                            return {
                                settings = {
                                    json = {
                                        schemas = require("schemastore").json.schemas(),
                                        validate = { enable = true },
                                    },
                                },
                            }
                        end,
                    },
                    {
                        server = "yamlls",
                        config = function()
                            return {
                                settings = {
                                    yaml = {
                                        schemas = require("schemastore").yaml.schemas(),
                                        keyOrdering = false,
                                    },
                                },
                            }
                        end,
                    },
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
                    { server = "intelephense" },
                    { server = "vtsls", disable_formatting = true },
                    { server = "rust_analyzer", adapter = "rustaceanvim", ensure = false },
                },
                diagnostics = {
                    config = {
                        virtual_text = false,
                        signs = true,
                        underline = true,
                        update_in_insert = false,
                        severity_sort = true,
                        float = { border = "rounded", source = true },
                    },
                },
            })
        end,
    },
}
