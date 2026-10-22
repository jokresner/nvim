-- On the Linux desktop, theme-apply.nu (nix repo) writes the active theme to
-- ~/.local/state/theme/current.json: `variant` is dark/light and
-- `ports.nvim` the colorscheme. Without that file (macOS) auto-dark-mode
-- switches catppuccin between mocha and latte as before.
local state_file = (vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")) .. "/theme/current.json"
local has_state = vim.uv.fs_stat(state_file) ~= nil

local function remember_background(bg)
    local f = io.open(vim.fn.stdpath("state") .. "/bg_state", "w")
    if f then
        f:write(bg)
        f:close()
    end
end

local function apply_state()
    local f = io.open(state_file, "r")
    if not f then
        return
    end
    local ok, state = pcall(vim.json.decode, f:read("*a"))
    f:close()
    -- A half-written file fails to parse; the next change event retries.
    if not ok or type(state) ~= "table" or not state.ports or not state.ports.nvim then
        return
    end
    local bg = state.variant == "light" and "light" or "dark"
    vim.o.background = bg
    pcall(vim.cmd.colorscheme, state.ports.nvim)
    remember_background(bg)
end

-- theme-apply.nu rewrites the file in place, so a file watch keeps working.
local function watch_state()
    local watcher = vim.uv.new_fs_event()
    if not watcher then
        return
    end
    watcher:start(state_file, {}, vim.schedule_wrap(function()
        apply_state()
    end))
end

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
            if has_state then
                apply_state()
                watch_state()
            end
        end,
    },
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        cond = not has_state,
        opts = {
            set_dark_mode = function()
                vim.o.background = "dark"
                vim.cmd.colorscheme("catppuccin")
                remember_background("dark")
            end,
            set_light_mode = function()
                vim.o.background = "light"
                vim.cmd.colorscheme("catppuccin")
                remember_background("light")
            end,
        },
    },
}
