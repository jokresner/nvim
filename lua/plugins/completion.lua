return {
    {
        "saghen/blink.cmp",
        version = "*",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            keymap = {
                ["<C-space>"] = { "show", "show_documentation", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            },
            appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
            signature = { enabled = true },
        },
    },
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                    accept_suggestion = "<Tab>",
                    clear_suggestion = "<C-q>",
                    accept_word = "<C-j>",
                },
            })
        end,
    },
}
