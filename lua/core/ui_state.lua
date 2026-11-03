-- Persisted UI toggles. Owns the JSON state file, re-applying saved window/buffer options,
-- and the diagnostic defaults (single owner, so nothing overrides a saved toggle later).
--
-- State file format: flat JSON object keyed by toggle id (spell, wrap, line_number, relativenumber,
-- diagnostics, diagnostic_virtual_text, treesitter, inlay_hints, indent) -> boolean.
local M = {}

M.diagnostic_defaults = {
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = true },
}

--- Read the state file. A missing, empty or corrupt file yields {}.
function M.read(path)
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
        return {}
    end
    local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
    if decoded_ok and type(decoded) == "table" then
        return decoded
    end
    return {}
end

function M.write(path, state)
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    vim.fn.writefile({ vim.json.encode(state) }, path)
end

--- Window options implied by the state. Pure: only keys with a saved value appear.
---@return table<string, boolean>
function M.window_options(state)
    local wo = {}
    if state.spell ~= nil then
        wo.spell = state.spell
    end
    if state.wrap ~= nil then
        wo.wrap = state.wrap
    end
    if state.line_number ~= nil then
        wo.number = state.line_number
        -- relative numbers only make sense while line numbers are on
        wo.relativenumber = state.line_number and state.relativenumber ~= false or false
    elseif state.relativenumber ~= nil then
        wo.relativenumber = state.relativenumber
    end
    return wo
end

function M.apply_window_state(state)
    for option, value in pairs(M.window_options(state)) do
        vim.wo[option] = value
    end
end

--- Wrap a Snacks toggle so every change is saved, restore its saved value, and map it.
function M.persist(state, save, toggle, lhs)
    local set = toggle.opts.set
    toggle.opts.set = function(value)
        set(value)
        state[toggle.opts.id] = value
        save()
    end
    if state[toggle.opts.id] ~= nil then
        toggle:set(state[toggle.opts.id])
    end
    toggle:map(lhs)
end

--- Wire everything. `snacks_toggle` is `require("snacks").toggle`.
---@param opts { path: string, toggle: table }
function M.setup(opts)
    local path, toggle = opts.path, opts.toggle
    local state = M.read(path)
    local function save()
        M.write(path, state)
    end
    local function persist(t, lhs)
        M.persist(state, save, t, lhs)
    end

    vim.diagnostic.config(M.diagnostic_defaults)

    persist(toggle.option("spell", { name = "Spelling" }), "<leader>us")
    persist(toggle.option("wrap", { name = "Wrap" }), "<leader>uw")
    persist(toggle.option("relativenumber", { name = "Relative number" }), "<leader>uL")
    persist(toggle.line_number(), "<leader>ul")
    persist(toggle.diagnostics(), "<leader>ud")
    persist(
        toggle({
            id = "diagnostic_virtual_text",
            name = "Diagnostic Virtual Text",
            get = function()
                return vim.diagnostic.config().virtual_text ~= false
            end,
            set = function(enabled)
                vim.diagnostic.config({
                    virtual_text = enabled and { severity = { min = vim.diagnostic.severity.WARN } } or false,
                })
            end,
        }),
        "<leader>uv"
    )
    persist(toggle.treesitter(), "<leader>uT")
    persist(toggle.inlay_hints(), "<leader>ui")
    persist(toggle.indent(), "<leader>ug")

    local group = vim.api.nvim_create_augroup("persisted_ui_toggles", { clear = true })
    M.apply_window_state(state)
    vim.api.nvim_create_autocmd({ "BufWinEnter", "WinNew" }, {
        group = group,
        callback = function(event)
            M.apply_window_state(state)
            if state.treesitter == false then
                pcall(vim.treesitter.stop, event.buf)
            end
        end,
    })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(event)
            if state.inlay_hints ~= nil then
                vim.lsp.inlay_hint.enable(state.inlay_hints, { bufnr = event.buf })
            end
        end,
    })

    return state
end

return M
