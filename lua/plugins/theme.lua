-- On the Linux desktop, theme-apply.nu (nix repo) writes the active theme to
-- ~/.local/state/theme/current.json: `variant` is dark/light and
-- `ports.nvim` the colorscheme. Without that file (macOS) auto-dark-mode
-- switches catppuccin between mocha and latte as before.
local theme = require("core.theme")

return {
    {
        "dgox16/oldworld.nvim",
        lazy = true,
    },
    { "rose-pine/neovim", name = "rose-pine", lazy = true },
    { "folke/tokyonight.nvim", lazy = true },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            default_integrations = false,
            auto_integrations = false,
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
            theme.setup(vim.fn.stdpath("state"))
        end,
    },
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        cond = not theme.has_external(),
        opts = {
            set_dark_mode = function()
                theme.set_background("dark")
            end,
            set_light_mode = function()
                theme.set_background("light")
            end,
        },
    },
}
