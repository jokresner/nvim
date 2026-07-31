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
            require("mini.tabline").setup({ tabpage_section = "right" })

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
}
