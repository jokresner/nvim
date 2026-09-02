return {
    {
        "dgox16/oldworld.nvim",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            default_integrations = false,
            flavour = "auto",
            background = { light = "latte", dark = "mocha" },
            transparent_background = false,
            integrations = {
                blink_cmp = { style = "bordered" },
                flash = true,
                markview = true,
                mini = { enabled = true, indentscope_color = "mauve" },
                neotest = true,
                noice = true,
                dap = true,
                which_key = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        opts = {
            set_dark_mode = function()
                vim.o.background = "dark"
                vim.cmd.colorscheme("catppuccin")
                local f = io.open(vim.fn.stdpath("state") .. "/bg_state", "w")
                if f then
                    f:write("dark")
                    f:close()
                end
            end,
            set_light_mode = function()
                vim.o.background = "light"
                vim.cmd.colorscheme("catppuccin")
                local f = io.open(vim.fn.stdpath("state") .. "/bg_state", "w")
                if f then
                    f:write("light")
                    f:close()
                end
            end,
        },
    },
}
