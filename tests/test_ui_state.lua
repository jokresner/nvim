local ui = require("core.ui_state")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

local function tmp()
    return vim.fn.tempname() .. "/ui_toggles.json"
end

T["state file"] = MiniTest.new_set()

T["state file"]["round-trips"] = function()
    local path = tmp()
    ui.write(path, { wrap = false, spell = true })
    eq(ui.read(path), { wrap = false, spell = true })
end

T["state file"]["missing file is empty state"] = function()
    eq(ui.read(tmp()), {})
end

T["state file"]["corrupt file is empty state"] = function()
    local path = tmp()
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    vim.fn.writefile({ "{ not json" }, path)
    eq(ui.read(path), {})
end

T["state file"]["non-object json is empty state"] = function()
    local path = tmp()
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    vim.fn.writefile({ "42" }, path)
    eq(ui.read(path), {})
end

T["window_options"] = MiniTest.new_set()

T["window_options"]["empty state sets nothing"] = function()
    eq(ui.window_options({}), {})
end

T["window_options"]["line numbers off forces relativenumber off"] = function()
    eq(ui.window_options({ line_number = false, relativenumber = true }), { number = false, relativenumber = false })
end

T["window_options"]["line numbers on keeps relativenumber unless saved off"] = function()
    eq(ui.window_options({ line_number = true }), { number = true, relativenumber = true })
    eq(ui.window_options({ line_number = true, relativenumber = false }), { number = true, relativenumber = false })
end

T["window_options"]["relativenumber alone"] = function()
    eq(ui.window_options({ relativenumber = false }), { relativenumber = false })
end

T["window_options"]["spell and wrap"] = function()
    eq(ui.window_options({ spell = true, wrap = false }), { spell = true, wrap = false })
end

T["persist"] = MiniTest.new_set()

local function fake_toggle(id)
    local t = { applied = {}, mapped = nil }
    t.opts = {
        id = id,
        set = function(value)
            table.insert(t.applied, value)
        end,
    }
    function t:set(value)
        self.opts.set(value)
    end
    function t:map(lhs)
        self.mapped = lhs
    end
    return t
end

T["persist"]["saves every change"] = function()
    local state, saves = {}, 0
    local t = fake_toggle("wrap")
    ui.persist(state, function() saves = saves + 1 end, t, "<leader>uw")
    eq(t.mapped, "<leader>uw")
    t.opts.set(false)
    eq(state.wrap, false)
    eq(saves, 1)
end

T["persist"]["restores a saved value once"] = function()
    local state, saves = { wrap = false }, 0
    local t = fake_toggle("wrap")
    ui.persist(state, function() saves = saves + 1 end, t, "<leader>uw")
    eq(t.applied, { false })
    eq(state.wrap, false)
end

-- core.ui_state is the only module that calls vim.diagnostic.config for defaults, so a saved
-- diagnostic_virtual_text toggle is restored after them and cannot be overridden later.
T["diagnostics"] = MiniTest.new_set()

T["diagnostics"]["defaults keep virtual_text off"] = function()
    eq(ui.diagnostic_defaults.virtual_text, false)
end

return T
