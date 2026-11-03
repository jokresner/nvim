local engine = require("core.lsp_engine")
local eq = MiniTest.expect.equality

local T = MiniTest.new_set()

T["install_names"] = function()
    eq(
        engine.install_names({
            { server = "b" },
            { server = "a" },
            { server = "nixd", ensure = false },
            { server = "rust_analyzer", adapter = "rustaceanvim" },
        }),
        { "a", "b" }
    )
end

T["resolve"] = MiniTest.new_set()

T["resolve"]["accepts a config function and does not mutate the record"] = function()
    local record = { server = "s", config = function() return { settings = { a = 1 } } end }
    local resolved = engine.resolve(record, { textDocument = { x = 1 } })
    eq(resolved.settings, { a = 1 })
    eq(resolved.capabilities.textDocument.x, 1)
end

T["resolve"]["disable_formatting runs before hooks"] = function()
    local order = {}
    local record = {
        server = "s",
        disable_formatting = true,
        on_attach = function() table.insert(order, "record") end,
        config = { on_attach = function() table.insert(order, "config") end },
    }
    local client = { server_capabilities = { documentFormattingProvider = true } }
    engine.resolve(record, {}).on_attach(client, 1)
    eq(client.server_capabilities.documentFormattingProvider, false)
    eq(order, { "config", "record" })
end

T["resolve"]["no hooks means no on_attach"] = function()
    eq(engine.resolve({ server = "s" }, {}).on_attach, nil)
end

T["record_keys"] = MiniTest.new_set()

T["record_keys"]["match by client name, falling back to server"] = function()
    local records = {
        { server = "rust_analyzer", client = "rust-analyzer", keys = { { "<leader>ca", "rust" } } },
        { server = "gopls", keys = { { "<leader>ca", "go" } } },
    }
    eq(engine.record_keys(records, "rust-analyzer")[1][2], "rust")
    eq(engine.record_keys(records, "gopls")[1][2], "go")
    eq(engine.record_keys(records, "other"), {})
end

-- Regression: a language's key must win over the default key on the same lhs.
T["on_attach"] = MiniTest.new_set()

T["on_attach"]["record keys override default keys"] = function()
    vim.g.mapleader = " "
    local buf = vim.api.nvim_create_buf(false, true)
    local rust = function() end
    engine.on_attach({
        { server = "rust_analyzer", client = "rust-analyzer", keys = { { "<leader>ca", rust, desc = "Rust" } } },
    }, buf, "rust-analyzer")
    local map = vim.api.nvim_buf_call(buf, function()
        return vim.fn.maparg(" ca", "n", false, true)
    end)
    eq(map.desc, "Rust")
end

return T
