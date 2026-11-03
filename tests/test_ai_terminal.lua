local ai = require("core.ai_terminal")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

local agents = {
    { id = "hx", cmd = "hx", key = "a", title = "Hx" },
    { id = "pi", cmd = "pi", key = "p", title = "Pi" },
}

local function make()
    local env = { warnings = {}, sent = {}, opened = {} }
    env.ai = ai.new({
        agents = agents,
        notify = function(msg)
            table.insert(env.warnings, msg)
        end,
        send = function(job, data)
            table.insert(env.sent, { job, data })
        end,
        terminal = function(cmd)
            local buf = vim.api.nvim_create_buf(false, true)
            vim.b[buf].terminal_job_id = 7
            table.insert(env.opened, cmd)
            env.buf = buf
            return { buf = buf }
        end,
    })
    return env
end

T["reference"] = MiniTest.new_set()

T["reference"]["path only and path:line"] = function()
    local cwd_file = vim.fn.getcwd() .. "/lua/x.lua"
    eq(ai.reference(cwd_file), "lua/x.lua")
    eq(ai.reference(cwd_file, 12), "lua/x.lua:12")
end

T["send"] = MiniTest.new_set()

T["send"]["without an agent warns and does not throw"] = function()
    local env = make()
    eq(env.ai.send("x"), false)
    eq(env.warnings, { "Open an AI agent first" })
end

T["send"]["reaches the active terminal job"] = function()
    local env = make()
    env.ai.open("pi")
    eq(env.opened, { "pi" })
    eq(env.ai.send("lua/x.lua:3"), true)
    eq(env.sent, { { 7, "lua/x.lua:3" } })
end

T["send"]["goes to the last opened agent"] = function()
    local env = make()
    env.ai.open("hx")
    env.ai.open("pi")
    eq(env.ai.active.id, "pi")
end

T["send"]["dead buffer warns"] = function()
    local env = make()
    env.ai.open("hx")
    vim.api.nvim_buf_delete(env.buf, { force = true })
    eq(env.ai.send("x"), false)
    eq(env.warnings, { "AI agent is not running: hx" })
end

T["send"]["no job warns"] = function()
    local env = make()
    env.ai.open("hx")
    vim.b[env.buf].terminal_job_id = nil
    eq(env.ai.send("x"), false)
    eq(env.warnings, { "AI agent has no active terminal job: hx" })
end

T["open"] = function()
    local env = make()
    env.ai.open("nope")
    eq(env.warnings, { "Unknown AI agent: nope" })
    eq(env.ai.active, nil)
end

T["edgy_views"] = MiniTest.new_set()

T["edgy_views"]["one view per agent matching only its own terminal"] = function()
    local views = ai.edgy_views(agents)
    eq(#views, 2)
    eq(views[1].title, "AI (Hx)")

    local hx, pi = vim.api.nvim_create_buf(false, true), vim.api.nvim_create_buf(false, true)
    vim.b[hx].snacks_terminal = { id = "hx" }
    vim.b[pi].snacks_terminal = { id = "pi" }
    local plain = vim.api.nvim_create_buf(false, true)

    eq(views[1].filter(hx), true)
    eq(views[1].filter(pi), false)
    eq(views[2].filter(pi), true)
    eq(views[2].filter(plain), false)
end

return T
