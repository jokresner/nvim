return {
    {
        "echasnovski/mini.nvim",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.ai").setup()
            require("mini.surround").setup()
            require("mini.comment").setup()
            require("mini.icons").setup()
            require("mini.indentscope").setup({ symbol = "|", options = { try_as_border = true } })

            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({ highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() } })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("mini_indentscope_disable", { clear = true }),
                pattern = { "help", "lazy", "mason", "snacks_picker" },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
            require("mini.diff").setup({
                mappings = {
                    goto_first = "",
                    goto_last = "",
                    goto_prev = "<leader>H",
                    goto_next = "<leader>h",
                    apply = "gh",
                    reset = "gH",
                },
            })
        end,
    },
    {
        "Wansmer/treesj",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = {
            {
                "<leader>cj",
                function()
                    require("treesj").toggle()
                end,
                desc = "Toggle block split/join",
            },
        },
        opts = { use_default_keymaps = false, max_join_length = 150 },
    },
}
