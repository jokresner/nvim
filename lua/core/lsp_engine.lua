local M = {}

local function server_name(record)
    return record.server
end

local function lsp_servers(records)
    local servers = {}
    for _, record in ipairs(records or {}) do
        if record.adapter == nil and record.ensure ~= false then
            table.insert(servers, server_name(record))
        end
    end
    table.sort(servers)
    return servers
end

local function resolve_user_config(record)
    local config = record.config
    if type(config) == "function" then
        config = config()
    end
    return vim.deepcopy(config or {})
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

local function resolve_config(record, capabilities)
    local resolved = resolve_user_config(record)
    resolved.capabilities =
        vim.tbl_deep_extend("force", capabilities, record.capabilities or {}, resolved.capabilities or {})
    resolved.on_attach = compose_on_attach(record, resolved)
    return resolved
end

local function setup_record(record, capabilities, lspconfig)
    if record.adapter then
        return
    end

    local name = server_name(record)
    local final_cfg = resolve_config(record, capabilities)
    if vim.lsp.config and vim.lsp.enable then
        vim.lsp.config(name, final_cfg)
        vim.lsp.enable(name)
    else
        lspconfig[name].setup(final_cfg)
    end
end

function M.setup_diagnostics(diagnostics)
    if not diagnostics or not diagnostics.config then
        return
    end
    vim.diagnostic.config(diagnostics.config)
end

function M.setup(opts)
    opts = opts or {}
    local records = opts.servers or {}

    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    for _, record in ipairs(records) do
        setup_record(record, capabilities, lspconfig)
    end

    require("mason-lspconfig").setup({
        ensure_installed = lsp_servers(records),
        automatic_enable = false,
    })

    M.setup_diagnostics(opts.diagnostics)
end

return M
