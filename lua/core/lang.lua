-- Language module: every language is one plain data table in `lua/langs/<name>.lua`.
-- This module merges them into lazy.nvim specs, one install list, one LSP server list,
-- one parser list and one FileType options autocmd. Language files never touch
-- lazy.nvim's merge rules.
--
-- Language table fields (all optional):
--   ft              filetypes this language owns (parser coverage + `options`)
--   parsers         treesitter parsers
--   parser_for      filetype -> parser when they differ (javascriptreact = "tsx")
--   tools           mason package names to install
--   external        formatter/linter ids provided outside mason (nix, toolchains)
--   servers         LSP server records, see core/lsp_engine.lua
--   formatters_by_ft, formatters   conform.nvim tables
--   linters_by_ft   nvim-lint table
--   test            { plugin = "author/neotest-x", adapter = function() return adapter end }
--   dap             { plugin = "author/dap-x"?, setup = function(dap) end }
--   options         buffer options applied on FileType for every `ft`
--   plugins         extra lazy.nvim specs only this language needs
local M = {}

local function append_unique(list, seen, value)
    if not seen[value] then
        seen[value] = true
        table.insert(list, value)
    end
end

local function install_name(record)
    if record.adapter == nil and record.ensure ~= false then
        return record.server
    end
end

--- Merge language tables. Pure: no plugin is required.
---@param langs table<string, table> name -> language table
function M.collect(langs)
    local merged = {
        install = {},
        servers = {},
        parsers = {},
        formatters_by_ft = {},
        formatters = {},
        linters_by_ft = {},
        tests = {},
        daps = {},
        options = {},
        plugins = {},
    }
    local seen_install, seen_parser = {}, {}

    local names = vim.tbl_keys(langs)
    table.sort(names)
    for _, name in ipairs(names) do
        local lang = langs[name]
        for _, tool in ipairs(lang.tools or {}) do
            append_unique(merged.install, seen_install, tool)
        end
        for _, record in ipairs(lang.servers or {}) do
            table.insert(merged.servers, record)
            local server = install_name(record)
            if server then
                append_unique(merged.install, seen_install, server)
            end
        end
        for _, parser in ipairs(lang.parsers or {}) do
            append_unique(merged.parsers, seen_parser, parser)
        end
        merged.formatters_by_ft = vim.tbl_extend("force", merged.formatters_by_ft, lang.formatters_by_ft or {})
        merged.formatters = vim.tbl_extend("force", merged.formatters, lang.formatters or {})
        merged.linters_by_ft = vim.tbl_extend("force", merged.linters_by_ft, lang.linters_by_ft or {})
        if lang.test then
            table.insert(merged.tests, lang.test)
        end
        if lang.dap then
            table.insert(merged.daps, lang.dap)
        end
        if lang.options then
            for _, ft in ipairs(lang.ft or {}) do
                merged.options[ft] = lang.options
            end
        end
        vim.list_extend(merged.plugins, lang.plugins or {})
    end

    table.sort(merged.install)
    return merged
end

local function normalize(id)
    return (id:gsub("[-_]", ""))
end

--- Find drift between languages. Pure. Returns a list of human-readable problems.
---@param langs table<string, table>
function M.check(langs)
    local problems = {}
    local owners = {}

    local names = vim.tbl_keys(langs)
    table.sort(names)
    for _, name in ipairs(names) do
        local lang = langs[name]

        local installs = vim.list_extend({}, lang.tools or {})
        for _, record in ipairs(lang.servers or {}) do
            local server = install_name(record)
            if server then
                table.insert(installs, server)
            end
        end
        for _, item in ipairs(installs) do
            if owners[item] then
                table.insert(problems, ("%s: '%s' is already installed by %s"):format(name, item, owners[item]))
            else
                owners[item] = name
            end
        end

        -- A formatter/linter id is covered by a mason tool (ignoring - and _),
        -- the language's `external` list, or a custom conform formatter definition.
        local provided = {}
        for _, tool in ipairs(lang.tools or {}) do
            provided[normalize(tool)] = true
        end
        for _, id in ipairs(lang.external or {}) do
            provided[normalize(id)] = true
        end
        local function check_ids(kind, by_ft)
            for ft, ids in pairs(by_ft or {}) do
                for _, id in ipairs(ids) do
                    if not provided[normalize(id)] then
                        table.insert(
                            problems,
                            ("%s: %s '%s' for %s is neither in tools nor external"):format(name, kind, id, ft)
                        )
                    end
                end
            end
        end
        check_ids("formatter", lang.formatters_by_ft)
        check_ids("linter", lang.linters_by_ft)

        local parsers = {}
        for _, parser in ipairs(lang.parsers or {}) do
            parsers[parser] = true
        end
        for _, ft in ipairs(lang.ft or {}) do
            local parser = (lang.parser_for or {})[ft] or vim.treesitter.language.get_lang(ft) or ft
            if not parsers[parser] then
                table.insert(problems, ("%s: filetype '%s' needs parser '%s'"):format(name, ft, parser))
            end
        end
    end

    table.sort(problems)
    return problems
end

--- Build lazy.nvim specs from merged languages. Pure.
function M.specs(merged)
    local function plugin_names(items)
        local deps = {}
        for _, item in ipairs(items) do
            if item.plugin then
                table.insert(deps, item.plugin)
            end
        end
        return deps
    end

    local specs = {
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            -- lspconfig server names are mapped to mason packages through mason-lspconfig
            dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
            opts_extend = { "ensure_installed" },
            opts = { ensure_installed = merged.install },
        },
        {
            "neovim/nvim-lspconfig",
            optional = true,
            opts_extend = { "servers" },
            opts = { servers = merged.servers },
        },
        {
            "stevearc/conform.nvim",
            optional = true,
            opts = function(_, opts)
                opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, merged.formatters_by_ft)
                opts.formatters = vim.tbl_extend("force", opts.formatters or {}, merged.formatters)
            end,
        },
        {
            "mfussenegger/nvim-lint",
            optional = true,
            opts = function(_, opts)
                opts.linters_by_ft = vim.tbl_extend("force", opts.linters_by_ft or {}, merged.linters_by_ft)
            end,
        },
        {
            "nvim-neotest/neotest",
            optional = true,
            dependencies = plugin_names(merged.tests),
            opts = function(_, opts)
                opts.adapters = opts.adapters or {}
                for _, test in ipairs(merged.tests) do
                    table.insert(opts.adapters, test.adapter())
                end
            end,
        },
        {
            "mfussenegger/nvim-dap",
            optional = true,
            dependencies = plugin_names(merged.daps),
            opts = function(_, opts)
                opts.adapters = opts.adapters or {}
                for _, dap in ipairs(merged.daps) do
                    table.insert(opts.adapters, dap.setup)
                end
            end,
        },
    }
    vim.list_extend(specs, merged.plugins)
    return specs
end

local cache, merged_cache

--- Load every `lua/langs/*.lua` from the config dir. Cached.
function M.load()
    if cache then
        return cache
    end
    local langs = {}
    local dir = vim.fn.stdpath("config") .. "/lua/langs"
    for name, kind in vim.fs.dir(dir) do
        if kind == "file" and name:sub(-4) == ".lua" then
            local mod = name:sub(1, -5)
            langs[mod] = require("langs." .. mod)
        end
    end
    cache = langs
    return langs
end

--- Merged view of the loaded languages. Cached.
function M.registry()
    merged_cache = merged_cache or M.collect(M.load())
    return merged_cache
end

--- Apply per-language buffer options on FileType.
function M.setup_options(options_by_ft)
    options_by_ft = options_by_ft or M.registry().options
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("core_lang_options", { clear = true }),
        pattern = vim.tbl_keys(options_by_ft),
        callback = function(event)
            for option, value in pairs(options_by_ft[event.match] or {}) do
                vim.bo[event.buf][option] = value
            end
        end,
    })
end

return M
