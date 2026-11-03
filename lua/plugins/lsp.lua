-- Server records come from the language files (lua/langs/*.lua) through
-- core.lang; core.lsp_engine owns configuration and attach keymaps.
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
        dependencies = { "williamboman/mason.nvim", "b0o/SchemaStore.nvim" },
        opts_extend = { "servers" },
        opts = { servers = {} },
        config = function(_, opts)
            require("core.lsp_engine").setup({ servers = opts.servers })
        end,
    },
}
