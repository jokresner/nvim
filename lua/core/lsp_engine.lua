-- LSP engine: server records in, configured clients and attach keymaps out.
--
-- A server record:
--   server              lspconfig name ("gopls")
--   client              LSP client name when it differs from `server` (rustaceanvim: "rust-analyzer")
--   config              table, or function returning one (for lazy requires like schemastore)
--   adapter             another plugin starts this client (e.g. "rustaceanvim"); engine only attaches keys
--   ensure              false to keep mason from installing it (nix, rustup, ...)
--   disable_formatting  drop the server's formatting capability (conform formats instead)
--   capabilities        extra client capabilities
--   on_attach           function(client, bufnr), runs after config.on_attach
--   keys                { { lhs, rhs, desc = ..., mode = ... } }, applied after the default keys
local M = {}

local function picker(method, fallback)
    return function()
        local ok, snacks = pcall(require, "snacks")
        if ok and snacks.picker and snacks.picker[method] then
            return snacks.picker[method]()
        end
        if fallback then
            fallback()
        end
    end
end

-- Wrapped so plugins that replace vim.lsp.buf.* (noice) are honoured at call time.
local function buf(method)
    return function()
        vim.lsp.buf[method]()
    end
end

M.default_keys = {
    { "K", buf("hover"), desc = "LSP hover" },
    { "gd", picker("lsp_definitions", buf("definition")), desc = "Go to definition" },
    { "gD", picker("lsp_declarations", buf("declaration")), desc = "Go to declaration" },
    { "gI", picker("lsp_implementations", buf("implementation")), desc = "Go to implementation" },
    { "gR", picker("lsp_references", buf("references")), desc = "Go to references" },
    { "gr", picker("lsp_references", buf("references")), desc = "Go to references", nowait = true },
    { "gy", picker("lsp_type_definitions", buf("type_definition")), desc = "Go to type definition" },
    { "gai", picker("lsp_incoming_calls"), desc = "Incoming calls" },
    { "gao", picker("lsp_outgoing_calls"), desc = "Outgoing calls" },
    { "<leader>ca", buf("code_action"), desc = "Code action" },
    { "<leader>cr", buf("rename"), desc = "Code rename" },
}

--- lspconfig names mason should install.
function M.install_names(records)
    local names = {}
    for _, record in ipairs(records or {}) do
        if record.adapter == nil and record.ensure ~= false then
            table.insert(names, record.server)
        end
    end
    table.sort(names)
    return names
end

local function compose_on_attach(record, config)
    local hooks = {}
    if config.on_attach then
        table.insert(hooks, config.on_attach)
    end
    if record.on_attach then
        table.insert(hooks, record.on_attach)
    end
    if not record.disable_formatting and #hooks == 0 then
        return nil
    end
    return function(client, bufnr)
        if record.disable_formatting then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end
        for _, hook in ipairs(hooks) do
            hook(client, bufnr)
        end
    end
end

--- Final vim.lsp.config table for a record.
function M.resolve(record, capabilities)
    local config = record.config
    if type(config) == "function" then
        config = config()
    end
    local resolved = vim.deepcopy(config or {})
    resolved.capabilities =
        vim.tbl_deep_extend("force", capabilities or {}, record.capabilities or {}, resolved.capabilities or {})
    resolved.on_attach = compose_on_attach(record, resolved)
    return resolved
end

--- Keys a record adds for a client name, in application order (applied after the defaults).
function M.record_keys(records, client_name)
    local keys = {}
    for _, record in ipairs(records or {}) do
        if (record.client or record.server) == client_name then
            vim.list_extend(keys, record.keys or {})
        end
    end
    return keys
end

local function set_keys(bufnr, keys)
    for _, key in ipairs(keys) do
        vim.keymap.set(key.mode or "n", key[1], key[2], {
            buffer = bufnr,
            silent = true,
            desc = key.desc,
            nowait = key.nowait,
        })
    end
end

--- Attach handler: default keys once per buffer, then the attaching client's record keys.
function M.on_attach(records, bufnr, client_name)
    if not vim.b[bufnr].lsp_engine_default_keys then
        set_keys(bufnr, M.default_keys)
        vim.b[bufnr].lsp_engine_default_keys = true
    end
    set_keys(bufnr, M.record_keys(records, client_name))
end

function M.setup(opts)
    local records = (opts or {}).servers or {}
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_engine_attach", { clear = true }),
        callback = function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client then
                M.on_attach(records, event.buf, client.name)
            end
        end,
    })

    for _, record in ipairs(records) do
        if not record.adapter then
            vim.lsp.config(record.server, M.resolve(record, capabilities))
            vim.lsp.enable(record.server)
        end
    end
end

return M
