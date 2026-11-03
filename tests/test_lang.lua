local lang = require("core.lang")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

T["collect"] = MiniTest.new_set()

T["collect"]["merges tools, servers and parsers without duplicates"] = function()
    local merged = lang.collect({
        a = { tools = { "x", "y" }, servers = { { server = "s1" } }, parsers = { "p" } },
        b = { tools = { "y", "z" }, servers = { { server = "s2", ensure = false } }, parsers = { "p", "q" } },
    })
    eq(merged.install, { "s1", "x", "y", "z" })
    eq(merged.parsers, { "p", "q" })
    eq(#merged.servers, 2)
end

T["collect"]["adapter servers are not installed"] = function()
    local merged = lang.collect({
        a = { servers = { { server = "rust_analyzer", adapter = "rustaceanvim" } } },
    })
    eq(merged.install, {})
end

T["collect"]["options are keyed by filetype"] = function()
    local merged = lang.collect({
        go = { ft = { "go", "gomod" }, options = { tabstop = 4 } },
    })
    eq(merged.options, { go = { tabstop = 4 }, gomod = { tabstop = 4 } })
end

T["check"] = MiniTest.new_set()

T["check"]["flags a tool installed by two languages"] = function()
    local problems = lang.check({
        a = { tools = { "x" } },
        b = { tools = { "x" } },
    })
    eq(#problems, 1)
    MiniTest.expect.no_equality(problems[1]:find("already installed"), nil)
end

T["check"]["flags a linter with no installer"] = function()
    local problems = lang.check({
        rust = { linters_by_ft = { rust = { "bacon" } } },
    })
    eq(#problems, 1)
    MiniTest.expect.no_equality(problems[1]:find("bacon", 1, true), nil)
end

T["check"]["accepts external and mason tools, ignoring - and _"] = function()
    local problems = lang.check({
        go = {
            tools = { "golangci-lint" },
            external = { "gofmt" },
            linters_by_ft = { go = { "golangcilint" } },
            formatters_by_ft = { go = { "gofmt" } },
        },
    })
    eq(problems, {})
end

T["check"]["flags a filetype without a parser"] = function()
    local problems = lang.check({ nix = { ft = { "nix" }, parsers = {} } })
    eq(#problems, 1)
end

-- The real languages in lua/langs must be consistent.
T["real languages"] = MiniTest.new_set()

T["real languages"]["have no drift"] = function()
    eq(lang.check(lang.load()), {})
end

T["real languages"]["install list has no duplicates"] = function()
    local install = lang.registry().install
    local seen = {}
    for _, name in ipairs(install) do
        eq(seen[name], nil)
        seen[name] = true
    end
end

T["specs"] = MiniTest.new_set()

T["specs"]["declare test and dap plugins as dependencies"] = function()
    local merged = lang.collect({
        go = {
            test = { plugin = "nvim-neotest/neotest-go", adapter = function() end },
            dap = { plugin = "leoluz/nvim-dap-go", setup = function() end },
        },
    })
    local by_name = {}
    for _, spec in ipairs(lang.specs(merged)) do
        by_name[spec[1]] = spec
    end
    eq(by_name["nvim-neotest/neotest"].dependencies, { "nvim-neotest/neotest-go" })
    eq(by_name["mfussenegger/nvim-dap"].dependencies, { "leoluz/nvim-dap-go" })
end

return T
