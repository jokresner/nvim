local theme = require("core.theme")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

local function tmpdir()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, "p")
    return dir
end

T["parse_external"] = MiniTest.new_set()

T["parse_external"]["reads variant and nvim port"] = function()
    eq(
        theme.parse_external('{"variant":"light","ports":{"nvim":"rose-pine"}}'),
        { background = "light", colorscheme = "rose-pine" }
    )
end

T["parse_external"]["unknown variant means dark"] = function()
    eq(theme.parse_external('{"ports":{"nvim":"tokyonight"}}').background, "dark")
end

T["parse_external"]["half-written or incomplete files are nil"] = function()
    eq(theme.parse_external('{"variant":"lig'), nil)
    eq(theme.parse_external(""), nil)
    eq(theme.parse_external(nil), nil)
    eq(theme.parse_external('{"variant":"dark"}'), nil)
    eq(theme.parse_external('{"ports":{"nvim":42}}'), nil)
end

T["cache"] = MiniTest.new_set()

T["cache"]["round-trips"] = function()
    local dir = tmpdir()
    theme.write_cache(dir, { background = "light", colorscheme = "oldworld" })
    eq(theme.read_cache(dir), { background = "light", colorscheme = "oldworld" })
end

T["cache"]["missing dir is empty"] = function()
    eq(theme.read_cache(tmpdir()), {})
end

T["cache"]["falls back to legacy bg_state"] = function()
    local dir = tmpdir()
    vim.fn.writefile({}, dir .. "/bg_state")
    local f = io.open(dir .. "/bg_state", "w")
    f:write("light")
    f:close()
    eq(theme.read_cache(dir), { background = "light" })
end

T["cache"]["drops invalid fields"] = function()
    local dir = tmpdir()
    local f = io.open(dir .. "/theme_cache.json", "w")
    f:write('{"background":"purple","colorscheme":""}')
    f:close()
    eq(theme.read_cache(dir), {})
end

T["preseed"] = function()
    local dir = tmpdir()
    theme.write_cache(dir, { background = "light", colorscheme = "x" })
    vim.o.background = "dark"
    theme.preseed(dir)
    eq(vim.o.background, "light")
end

T["logical_name"] = function()
    eq(theme.logical_name("catppuccin-mocha"), "catppuccin")
    eq(theme.logical_name("catppuccin-latte"), "catppuccin")
    eq(theme.logical_name("catppuccin"), "catppuccin")
    eq(theme.logical_name("tokyonight-moon"), "tokyonight-moon")
    eq(theme.logical_name(nil), nil)
end

T["remember"] = MiniTest.new_set()

T["remember"]["stores the logical catppuccin name, not the resolved flavour"] = function()
    local dir = tmpdir()
    theme.remember(dir)
    vim.o.background = "dark"
    vim.g.colors_name = "catppuccin-mocha"
    vim.api.nvim_exec_autocmds("ColorScheme", {})
    eq(theme.read_cache(dir).colorscheme, "catppuccin")
end

-- Any ColorScheme event (picker, auto-dark-mode, external file) updates the cache.
T["remember"]["saves background and colorscheme on ColorScheme"] = function()
    local dir = tmpdir()
    theme.remember(dir)
    vim.o.background = "light"
    vim.g.colors_name = "from-the-picker"
    vim.api.nvim_exec_autocmds("ColorScheme", {})
    eq(theme.read_cache(dir), { background = "light", colorscheme = "from-the-picker" })
end

return T
